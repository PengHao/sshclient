//
//  MTView.h
//  MobileTerminal
//
//  Created by Steven Troughton-Smith on 23/03/2016.
//  Copyright © 2016 High Caffeine Content. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VT100TextView;
@class PTY;

@protocol MTViewDelegate <NSObject>

- (BOOL)hasText;
- (void)insertText:(NSString *)text;
- (void)deleteBackward;

@end

@interface MTView : UIView <UIKeyInput, NSStreamDelegate>
{
	VT100TextView *textView;
	NSInputStream *inputStream;
	CADisplayLink *link;
	NSFileHandle *stdOutHandle;
	PTY* pty;
	NSMutableArray *commandHistory;
	//NSMutableString *textBuffer;

}
@property(nonatomic, weak) id<MTViewDelegate> delegate;

+ (instancetype)sharedInstance;
-(NSMutableString *)textBuffer;
- (void)onHandleInsertText:(NSString *)text;
- (void)onHandleDelete;
@end
