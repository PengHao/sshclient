//
//  KeyCode.h
//  libssh2-for-iOS
//
//  Created by peng hao on 2017/6/25.
//
//

#ifndef KeyCode_h
#define KeyCode_h

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    Reserved = 0x00,
    ErrorRollOver = 0x01,
    POSTFail = 0x02,
    ErrorUndefined = 0x03,
    A = 0x04,
    B = 0x05,
    C = 0x06,
    D = 0x07,
    E = 0x08,
    F = 0x09,
    G = 0x0A,
    H = 0x0B,
    I = 0x0C,
    J = 0x0D,
    K = 0x0E,
    L = 0x0F,
    M = 0x10,
    N = 0x11,
    O = 0x12,
    P = 0x13,
    Q = 0x14,
    R = 0x15,
    S = 0x16,
    T = 0x17,
    U = 0x18,
    V = 0x19,
    W = 0x1A,
    X = 0x1B,
    Y = 0x1C,
    Z = 0x1D,
    NUM1 = 0x1E,	//Keyboard 1 and !
    NUM2 = 0x1F,	//Keyboard 2 and @
    NUM3 = 0x20,	//Keyboard 3 and #
    NUM4 = 0x21,	//Keyboard 4 and $
    NUM5 = 0x22,	//Keyboard 5 and %
    NUM6 = 0x23,	//Keyboard 6 and ^
    NUM7 = 0x24,	//Keyboard 7 and &
    NUM8 = 0x25,	//Keyboard 8 and *
    NUM9 = 0x26,	//Keyboard 9 and (
    NUM0 = 0x27,	//Keyboard 0 and )
    
    ReturnEnter = 0x28,	//Keyboard Return (ENTER)
    Escape = 0x29,	//Keyboard ESCAPE
    Delete = 0x2A,	//Keyboard DELETE (Backspace)
    Tab = 0x2B,	//Keyboard Tab
    Space = 0x2C,	//Keyboard Spacebar
    Minus = 0x2D,	//Keyboard - and (underscore)
    Plus = 0x2E,	//Keyboard = and +
    LeftBracket = 0x2F,	//Keyboard [ and {
    RightBracket = 0x30,	//Keyboard ] and }
    Slash = 0x31,	//Keyboard \ and |
    NonUSWellNo = 0x32,	//Keyboard Non-US # and ~
    semicolon = 0x33,	//Keyboard ; and :
    quote = 0x34,	//Keyboard ' and "
    GraveAccent = 0x35,	//Keyboard Grave Accent and Tilde
    comma = 0x36,	//Keyboard, and <
    FullStop = 0x37,	//Keyboard . and >
    Backslash = 0x38,	//Keyboard / and ?
    CapsLock = 0x39,	//Keyboard Caps Lock
    F1 = 0x3A,	//Keyboard F1
    F2 = 0x3B,	//Keyboard F2
    F3 = 0x3C,	//Keyboard F3
    F4 = 0x3D,	//Keyboard F4
    F5 = 0x3E,	//Keyboard F5
    F6 = 0x3F,	//Keyboard F6
    F7 = 0x40,	//Keyboard F7
    F8 = 0x41,	//Keyboard F8
    F9 = 0x42,	//Keyboard F9
    F10 = 0x43,	//Keyboard F10
    F11 = 0x44,	//Keyboard F11
    F12 = 0x45,	//Keyboard F12
    PrintScreen = 0x46,	//Keyboard PrintScreen
    ScrollLock = 0x47,	//Keyboard Scroll Lock
    Pause = 0x48,	//Keyboard Pause
    Insert = 0x49,	//Keyboard Insert
    Home = 0x4A,	//Keyboard Home
    PageUp = 0x4B,	//Keyboard PageUp
    DeleteForward = 0x4C,	//Keyboard Delete Forward
    End = 0x4D,	//Keyboard End
    PageDown = 0x4E,	//Keyboard PageDown
    RightArrow = 0x4F,	//Keyboard RightArrow
    LeftArrow = 0x50,	//Keyboard LeftArrow
    DownArrow = 0x51,	//Keyboard DownArrow
    UpArrow = 0x52,	//Keyboard UpArrow
    
    KeypadNumLock = 0x53,	//Keypad Num Lock and Clear
    KeypadBackslash = 0x54,	//Keypad /
    KeypadStar = 0x55,	//Keypad *
    KeypadMinus = 0x56,	//Keypad -
    KeypadPlus = 0x57,	//Keypad +
    KeypadENTER = 0x58,	//Keypad ENTER
    Keypad1 = 0x59,	//Keypad 1 and End
    Keypad2 = 0x5A,	//Keypad 2 and Down Arrow
    Keypad3 = 0x5B,	//Keypad 3 and PageDn
    Keypad4 = 0x5C,	//Keypad 4 and Left Arrow
    Keypad5 = 0x5D,	//Keypad 5
    Keypad6 = 0x5E,	//Keypad 6 and Right Arrow
    Keypad7 = 0x5F,	//Keypad 7 and Home
    Keypad8 = 0x60,	//Keypad 8 and Up Arrow
    Keypad9 = 0x61,	//Keypad 9 and PageUp
    Keypad0 = 0x62,	//Keypad 0 and Insert
    KeypadDelete = 0x63,	//Keypad . and Delete
    
    NonUSSlash = 0x64,	//Keyboard Non-US \ and |
    Application = 0x65,	//Keyboard Application
    Power = 0x66,	//Keyboard Power
    KeypadEqual = 0x67,	//Keypad =
    F13 = 0x68,	//Keyboard F13
    F14 = 0x69,	//Keyboard F14
    F15 = 0x6A,	//Keyboard F15
    F16 = 0x6B,	//Keyboard F16
    F17 = 0x6C,	//Keyboard F17
    F18 = 0x6D,	//Keyboard F18
    F19 = 0x6E,	//Keyboard F19
    F20 = 0x6F,	//Keyboard F20
    F21 = 0x70,	//Keyboard F21
    F22 = 0x71,	//Keyboard F22
    F23 = 0x72,	//Keyboard F23
    F24 = 0x73,	//Keyboard F24
    Execute = 0x74,	//Keyboard Execute
    Help = 0x75,	//Keyboard Help
    Menu = 0x76,	//Keyboard Menu
    Select = 0x77,	//Keyboard Select
    Stop = 0x78,	//Keyboard Stop
    Again = 0x79,	//Keyboard Again
    Undo = 0x7A,	//Keyboard Undo
    Cut = 0x7B,	//Keyboard Cut
    Copy = 0x7C,	//Keyboard Copy
    Paste = 0x7D,	//Keyboard Paste
    Find = 0x7E,	//Keyboard Find
    Mute = 0x7F,	//Keyboard Mute
    VolumeUp = 0x80,	//Keyboard Volume Up
    VolumeDown = 0x81,	//Keyboard Volume Down
    LockingCapsLock = 0x82,	//Keyboard Locking Caps Lock
    LockingNumLock = 0x83,	//Keyboard Locking Num Lock
    LockingScrollLock = 0x84,	//Keyboard Locking Scroll Lock
    KeypadComm = 0x85,	//Keypad Comma
    EqualSign = 0x86,	//Keypad Equal Sign
    International1 = 0x87,	//Keyboard International1
    International2 = 0x88,	//Keyboard International2
    International3 = 0x89,	//Keyboard International3
    International4 = 0x8A,	//Keyboard International4
    International5 = 0x8B,	//Keyboard International5
    International6 = 0x8C,	//Keyboard International6
    International7 = 0x8D,	//Keyboard International7
    International8 = 0x8E,	//Keyboard International8
    International9 = 0x8F,	//Keyboard International9
    LANG1 = 0x90,	//Keyboard LANG1
    LANG2 = 0x91,	//Keyboard LANG2
    LANG3 = 0x92,	//Keyboard LANG3
    LANG4 = 0x93,	//Keyboard LANG4
    LANG5 = 0x94,	//Keyboard LANG5
    LANG6 = 0x95,	//Keyboard LANG6
    LANG7 = 0x96,	//Keyboard LANG7
    LANG8 = 0x97,	//Keyboard LANG8
    LANG9 = 0x98,	//Keyboard LANG9
    AlternateErase = 0x99,	//Keyboard Alternate Erase
    SysReq = 0x9A,	//Keyboard SysReq/Attention
    Cancel = 0x9B,	//Keyboard Cancel
    Clear = 0x9C,	//Keyboard Clear
    Prior = 0x9D,	//Keyboard Prior
    Return = 0x9E,	//Keyboard Return
    Separator = 0x9F,	//Keyboard Separator
    Out = 0xA0,	//Keyboard Out
    Oper = 0xA1,	//Keyboard Oper
    ClearAgain = 0xA2,	//Keyboard Clear/Again
    CrSel = 0xA3,	//Keyboard CrSel/Props
    ExSel = 0xA4,	//Keyboard ExSel
    LeftControl = 0xE0,	//Keyboard LeftControl
    LeftShift = 0xE1,	//Keyboard LeftShift
    LeftAlt = 0xE2,	//Keyboard LeftAlt
    LeftGUI = 0xE3,	//Keyboard Left GUI
    RightControl = 0xE4,	//Keyboard RightControl
    RightShift = 0xE5,	//Keyboard RightShift
    RightAlt = 0xE6,	//Keyboard RightAlt
    RightGUI = 0xE7,	//Keyboard Right GUI
    
} HIDCode;
#endif /* KeyCode_h */
