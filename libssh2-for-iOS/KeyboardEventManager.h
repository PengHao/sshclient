//
//  KeyboardEventManager.h
//  Vim
//
//  Created by peng hao on 2017/6/19.
//
//

#import <Foundation/Foundation.h>

// ASCII码1，2，3...分别依次对应键盘按键的Ctrl+A键，Ctrl+B键，Ctrl+C键，...Ctrl+Z键的
//ASCII为26.参考大写字母后的编码，按键Ctrl+[键产生ASCII码27，Ctrl+\键产生ASCII码28，Ctrl+]
//键产生ASCII码29，Ctrl+^键产生ASCII码30。
#define ESC_CODE 0x29
#define CTL_C 0x03

typedef void(^KeyBoardObserverBlock)(BOOL);
@interface KeyboardEventManager : NSObject
@property(nonatomic, readonly) BOOL isLeftCommandDown;  //227
@property(nonatomic, readonly) BOOL isLeftOptionDown;   //226
@property(nonatomic, readonly) BOOL isLeftShiftDown;    //225
@property(nonatomic, readonly) BOOL isLeftCtrlDown;     //224

+(instancetype) sharedKeyboardEventManager;
- (void) handleKey:(NSInteger) keyCode isPressDown:(BOOL) down;

- (void) addObserver:(NSInteger) keyCode block:(KeyBoardObserverBlock) block;

@end
