//
//  CCZTCircleView.m
//  CustomCircleZoomTransition
//
//  Created by Stuart Morris on 09/05/2014.
//  Copyright (c) 2014 Morris Projects Ltd. All rights reserved.
//

#import "CCZTCircleView.h"

@implementation CCZTCircleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCustomView];
    }
    return self;
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupCustomView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupCustomView];
    }
    return self;
}

-(void)setupCustomView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    float newRadius = self.frame.size.width/2;
    self.layer.cornerRadius = newRadius;
    self.layer.masksToBounds= YES;
    
    self.layer.borderWidth = 5;
    self.layer.borderColor = [UIColor colorWithRed:0.138 green:0.225 blue:1.000 alpha:1.000].CGColor;
    
    
    self.backgroundColor = [self randomColor];
}

-(UIColor *)randomColor {
    static NSMutableArray *__colors = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __colors = [NSMutableArray arrayWithArray:@[[UIColor colorWithRed:.11372549  green:.819607843 blue:.819607843 alpha:1.0], //29,209,99
                                                    [UIColor colorWithRed:.882352941 green:.466666667 blue:.709803922 alpha:1.0], //225,119,181
                                                    [UIColor colorWithRed:.647058824 green:.164705882 blue:.482352941 alpha:1.0], //165,42,123
                                                    [UIColor colorWithRed:.482352941 green:.17254902  blue:.733333333 alpha:1.0], //123,44,187
                                                    [UIColor colorWithRed:.219607843 green:.098039216 blue:.698039216 alpha:1.0], //56,25,178
                                                    [UIColor colorWithRed:.678431373 green:.843137255 blue:.274509804 alpha:1.0]  //173,215,70
                                                    ]];
    });
    int index = arc4random_uniform((uint32_t)__colors.count);
    
    UIColor *color = __colors[index];
    [__colors removeObjectAtIndex:index];
    return color;
}



@end
