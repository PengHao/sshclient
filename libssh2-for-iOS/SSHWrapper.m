//
//  SSHWrapper.m
//  libssh2-for-iOS
//
//  Created by Felix Schulze on 01.02.11.
//  Copyright 2010 Felix Schulze. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  @see: http://www.libssh2.org/examples/ssh2_exec.html

#import "SSHWrapper.h"

#include "libssh2.h"
#include "libssh2_sftp.h"
#include <sys/socket.h>
#include <arpa/inet.h>




static int waitsocket(int socket_fd, LIBSSH2_SESSION *session)
{
    struct timeval timeout;
    int rc;
    fd_set fd;
    fd_set *writefd = NULL;
    fd_set *readfd = NULL;
    int dir;

    timeout.tv_sec = 1;
    timeout.tv_usec = 0;

    FD_ZERO(&fd);

    FD_SET(socket_fd, &fd);

    /* now make sure we wait in the correct direction */
    
    dir = libssh2_session_block_directions(session);

    if(dir & LIBSSH2_SESSION_BLOCK_INBOUND)
        readfd = &fd;

    if(dir & LIBSSH2_SESSION_BLOCK_OUTBOUND)
        writefd = &fd;

    rc = select(socket_fd + 1, readfd, writefd, NULL, &timeout);

    return rc;
}

@implementation SSHWrapper {
    int sock;
    LIBSSH2_SESSION *session;
    LIBSSH2_CHANNEL *channel;
    dispatch_semaphore_t semaphore;
}

- (void)dealloc {
    [self closeConnection];
    session = nil;
    channel = nil;
}

- (instancetype)initWithHost:(NSString *)host port:(NSInteger) port {
    if (host.length == 0) {
        return nil;
    }
    if (libssh2_init (0) != 0) {
        NSLog(@"libssh2 initialization failed");
        return nil;
    }
    self = [super init];
    if (self) {
        _host = host;
        _port = port;
        semaphore = dispatch_semaphore_create(1);
    }
    return self;
}


- (void)auth:(NSString *)user password:(NSString *)password error:(NSError **)error {
    
    
    const char* userChar = [user cStringUsingEncoding:NSUTF8StringEncoding];
    const char* passwordChar = [password cStringUsingEncoding:NSUTF8StringEncoding];
    
    if ( strlen(passwordChar) != 0 ) {
        /* We could authenticate via password */
        int rc = 0;
        while ((rc = libssh2_userauth_password(session, userChar, passwordChar)) == LIBSSH2_ERROR_EAGAIN);
        if (rc) {
            *error = [NSError errorWithDomain:@"de.felixschulze.sshwrapper" code:403 userInfo:@{NSLocalizedDescriptionKey : @"Authentication by password failed."}];
            return;
        }
    }
}

- (void)connectUser:(NSString *)user password:(NSString *)password error:(NSError **)error {
    
    const char* hostChar = [_host cStringUsingEncoding:NSUTF8StringEncoding];
    struct sockaddr_in sock_serv_addr;
    unsigned long hostaddr = inet_addr(hostChar);
    sock = socket(AF_INET, SOCK_STREAM, 0);
    sock_serv_addr.sin_family = AF_INET;
    sock_serv_addr.sin_port = htons(_port);
    sock_serv_addr.sin_addr.s_addr = hostaddr;
    if (connect(sock, (struct sockaddr *) (&sock_serv_addr), sizeof(sock_serv_addr)) != 0) {
        *error = [NSError errorWithDomain:@"de.felixschulze.sshwrapper" code:400 userInfo:@{NSLocalizedDescriptionKey:@"Failed to connect"}];
        return;
    }
	
    /* Create a session instance */
    session = libssh2_session_init();
    if (!session) {
        *error = [NSError errorWithDomain:@"de.felixschulze.sshwrapper" code:401 userInfo:@{NSLocalizedDescriptionKey : @"Create session failed"}];
        return;
    }
    
    if (libssh2_session_handshake(session, sock)) {
        *error = [NSError errorWithDomain:@"de.felixschulze.sshwrapper" code:401 userInfo:@{NSLocalizedDescriptionKey : @"Failure establishing SSH session"}];
        return;
    }
	
    [self auth:user password:password error:error];
    if (*error != nil) {
        return;
    }
    
    if (!(channel = libssh2_channel_open_session(session))) {
        *error = [NSError errorWithDomain:@"de.felixschulze.sshwrapper" code:403 userInfo:@{NSLocalizedDescriptionKey : @"Unable to open a session."}];
        return;
    }
    
    if (libssh2_channel_request_pty(channel, "vanilla")) {
        *error = [NSError errorWithDomain:@"de.felixschulze.sshwrapper" code:403 userInfo:@{NSLocalizedDescriptionKey : @"Failed requesting pty"}];
        return;
    }
    
    /* Open a SHELL on that pty */
    if (libssh2_channel_shell(channel)) {
        *error = [NSError errorWithDomain:@"de.felixschulze.sshwrapper" code:403 userInfo:@{NSLocalizedDescriptionKey : @"Unable to request shell on allocated pty"}];
        return;
    }
    
    __weak SSHWrapper *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0*NSEC_PER_SEC), dispatch_get_global_queue(0, 0), ^{
        [weakSelf read];
    });
    
    [self send:"" error:nil];
}

- (void)send:(const char* )buffer error:(NSError **)error {
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    size_t len = strlen(buffer);
    size_t rc = libssh2_channel_write(channel, buffer, len);
    if (rc != len) {
        *error = [NSError errorWithDomain:@"de.felixschulze.sshwrapper" code:403 userInfo:@{NSLocalizedDescriptionKey : @"send error"}];
        return;
    }
    dispatch_semaphore_signal(semaphore);
}

- (void)readImpl {
    if (waitsocket(sock, session)<=0) {
        //no data aa
        return;
    }
    size_t len = 0x2000;
    char buffer[0x2000] = {0};
    NSMutableString *result = [[NSMutableString alloc] init];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    size_t l = 0;
    do {
        l = libssh2_channel_read( channel, buffer, sizeof(buffer));
        NSString *str = [[NSString alloc] initWithUTF8String:buffer];
        if (str) {
            [result appendString:str];
        }
    } while (l == len);
    dispatch_semaphore_signal(semaphore);
    __weak SSHWrapper *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.delegate onHandleData:result];
    });
}

- (void)read{
    __weak SSHWrapper *weakSelf = self;
    while ( channel && !libssh2_channel_eof(channel)) {
        [weakSelf readImpl];
    }
}



- (void)closeConnection {
    if (session) {
        libssh2_session_disconnect(session, "Normal Shutdown, Thank you for playing");
        libssh2_session_free(session);
        session = nil;
        libssh2_channel_close(channel);
        channel = nil;
    }
    close(sock);
}

@end
