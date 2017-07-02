//
//  KeyboardEventManager.m
//  Vim
//
//  Created by peng hao on 2017/6/19.
//
//

#import "KeyboardEventManager.h"
#import "KeyCode.h"


static KeyboardEventManager* singleKeyboardEventManager;
@interface KeyboardEventManager()
@property(nonatomic, strong) NSMutableDictionary *dictonary;

@end

@implementation KeyboardEventManager
+(instancetype) sharedKeyboardEventManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleKeyboardEventManager = [[KeyboardEventManager alloc] init];
    });
    return singleKeyboardEventManager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.dictonary = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void) addObserver:(NSInteger) keyCode block:(KeyBoardObserverBlock) block {
    NSString* key = [NSString stringWithFormat:@"%ld", (long)keyCode];
    NSMutableArray *array = [self.dictonary objectForKey:key];
    if (array == nil) {
        array = [NSMutableArray array];
        [self.dictonary setObject:array forKey:key];
    }
    
    if ([array containsObject:block]) {
        return;
    } else {
        block = (__bridge KeyBoardObserverBlock)Block_copy((__bridge void *)block);
        [array addObject:block];
    }
}


- (void) handleKey:(NSInteger) keyCode isPressDown:(BOOL) down {
    switch (keyCode) {
        case LeftControl:
        case RightControl:
            _isLeftCtrlDown = down;
            break;
        case LeftShift:
        case RightShift:
            _isLeftShiftDown = down;
            break;
        case LeftAlt:
        case RightAlt:
            _isLeftOptionDown = down;
            break;
        case LeftGUI:
        case RightGUI:
            _isLeftCommandDown = down;
            break;
        default:
            break;
    }
    if (_isLeftCtrlDown || _isLeftOptionDown || _isLeftCommandDown) {
        
    }
    NSString* key = [NSString stringWithFormat:@"%ld", (long)keyCode];
    NSMutableArray *array = [self.dictonary objectForKey:key];
    if (array == nil) {
        return;
    }
    for (KeyBoardObserverBlock block in array) {
        block(down);
    }
}
@end
