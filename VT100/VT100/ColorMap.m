// ColorMap.m
// MobileTerminal

#import "ColorMap.h"
#import "VT100Terminal.h"

// 16 terminal color slots available
//static const int kNumTerminalColors = 16;

@implementation ColorMap

@synthesize background;
@synthesize foreground;
@synthesize foregroundBold;
@synthesize foregroundCursor;
@synthesize backgroundCursor;

- (void)initColorTable
{
  // System 7.5 colors, why not?
  // black
  table[0] = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
  // dark red
  table[1] = [UIColor colorWithRed:0.6f green:0.0f blue:0.0f alpha:1.0f];
  // dark green
  table[2] = [UIColor colorWithRed:0.0f green:0.6f blue:0.0f alpha:1.0f];
  // dark yellow
  table[3] = [UIColor colorWithRed:0.6f green:0.4f blue:0.0f alpha:1.0f];
  // dark blue
  table[4] = [UIColor colorWithRed:0.0f green:0.0f blue:0.6f alpha:1.0f];
  // dark magenta
  table[5] = [UIColor colorWithRed:0.6f green:0.0f blue:0.6f alpha:1.0f];
  // dark cyan
  table[6] = [UIColor colorWithRed:0.0f green:0.6f blue:0.6f alpha:1.0f];
  // dark white
  table[7] = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f];
  // black
  table[8] = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
  // red
  table[9] = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
  // green
  table[10] = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0f];
  // yellow
  table[11] = [UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:1.0f];
  // blue
  table[12] = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f];
  // magenta
  table[13] = [UIColor colorWithRed:1.0f green:0.0f blue:1.0f alpha:1.0f];
  // light cyan
  table[14] = [UIColor colorWithRed:0.0f green:1.0f blue:1.0f alpha:1.0f];
  // white
  table[15] = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
}

- (id)init
{
  return [self initWithCoder:nil];
}

- (id)initWithCoder:(NSCoder *)decoder
{
  self = [super init];
  if (self != nil) {    
    [self initColorTable];
    if ([decoder containsValueForKey:@"background"]) {
      background = [decoder decodeObjectForKey:@"background"];
    } else {
      background = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    }
    if ([decoder containsValueForKey:@"foreground"]) {
      foreground = [decoder decodeObjectForKey:@"foreground"];
    } else {
      foreground = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.95f];
    }
    if ([decoder containsValueForKey:@"foregroundBold"]) {
      foregroundBold = [decoder decodeObjectForKey:@"foregroundBold"];
    } else {
      foregroundBold = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    }
    if ([decoder containsValueForKey:@"foregroundCursor"]) {
      foregroundCursor = [decoder decodeObjectForKey:@"foregroundCursor"];
    } else {
      foregroundCursor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.95f];
    }
    if ([decoder containsValueForKey:@"backgroundCursor"]) {
      backgroundCursor = [decoder decodeObjectForKey:@"backgroundCursor"];
    } else {
      backgroundCursor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.4f];
    }
  }
  return self;
}

- (void) dealloc
{
    
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
  [encoder encodeObject:background forKey:@"background"];
  [encoder encodeObject:foreground forKey:@"foreground"];
  [encoder encodeObject:foregroundBold forKey:@"foregroundBold"];
  [encoder encodeObject:foregroundCursor forKey:@"foregroundCursor"];
  [encoder encodeObject:backgroundCursor forKey:@"backgroundCursor"];
}

- (UIColor*) color:(unsigned int)index;
{
  // TODO(allen): The logic here is pretty ad hoc and could use some
  // some helpful comments describing whats its doing.  It seems to work?  
  if (index & COLOR_CODE_MASK)
  {
    switch (index) {
      case CURSOR_TEXT:
        return foregroundCursor;
      case CURSOR_BG:
        return backgroundCursor;
      case BG_COLOR_CODE:
        return background;
      default:
        if (index & BOLD_MASK) {
          if (index - BOLD_MASK == BG_COLOR_CODE) {
            return background;
          } else {
            return foregroundBold;
          }
        } else {
          return foreground;
        }
    }
  } else {
    index &= 0xff;
    if (index < 16) {
      return table[index];
    } else if (index < 232) {
      index -= 16;
      float components[] = {
        (index / 36) ? ((index / 36) * 40 + 55) / 256.0 : 0,
        (index % 36) / 6 ? (((index % 36) / 6) * 40 + 55 ) / 256.0 : 0,
        (index % 6) ? ((index % 6) * 40 + 55) / 256.0 : 0,
        1.0
      };
      return [UIColor colorWithRed:components[0] green:components[1]
                              blue:components[2]
                             alpha:1.0f];
    } else {
      return foreground;
    }
  }
}

@end
