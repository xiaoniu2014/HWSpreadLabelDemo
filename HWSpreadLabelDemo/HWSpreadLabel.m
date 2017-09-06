//
//  HWSpreadLabel.m
//  Demo
//
//  Created by hongw on 2017/9/6.
//  Copyright © 2017年 hongw. All rights reserved.
//

#import "HWSpreadLabel.h"
#import <CoreText/CoreText.h>


@interface HWSpreadLabel ()

@end

@implementation HWSpreadLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.open = NO;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.open = NO;
    self.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.open = !self.open;
    [self setUpAttributedText];
}

- (void)setUpAttributedText {
    NSArray *array = [self getLinesArrayOfStringInLabel];
    if (array.count <= 1) {
        self.attributedText = [self setUpSpecialWord:nil withText:self.originalText];
    } else {
        if (self.open) {
            NSString *specialStr = @"收起";
            NSString *str = [self.originalText stringByAppendingString:specialStr];
            self.attributedText = [self setUpSpecialWord:specialStr withText:str];
        } else {
            NSString *specialStr = @"...展开";
            NSString *str = [NSString stringWithFormat:@"%@%@",array[0],array[1]];
            str = [str substringToIndex:str.length - specialStr.length + 2];
            str = [str stringByAppendingString:specialStr];
            self.attributedText = [self setUpSpecialWord:specialStr withText:str];
        }
    }
    
    
    CGSize size = [self.attributedText boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    CGRect frame = self.frame;
    frame.size.height = size.height;
    self.frame = frame;
}


- (void)setOriginalText:(NSString *)originalText {
    _originalText = [originalText copy];
    [self setUpAttributedText];
}


- (NSAttributedString *)setUpSpecialWord:(NSString *)specialWord withText:(NSString *)text {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
    if (specialWord && specialWord.length > 0) {
        NSRange specialRange = [text rangeOfString:specialWord];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:specialRange];
    }
    return attStr;
}

- (NSArray *)getLinesArrayOfStringInLabel {
    NSString *text = self.originalText;
    UIFont *font = self.font;
    CGRect rect = self.frame;
    
    CTFontRef myFont = CTFontCreateWithName((CFStringRef)font.fontName,font.pointSize,NULL);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc] init];
    
    for (id line in lines) {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    
    return (NSArray *)linesArray;
}

@end
