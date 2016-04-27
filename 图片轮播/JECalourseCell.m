//
//  JECalourseCell.m
//  图片轮播
//
//  Created by 李佳佳 on 16/4/27.
//  Copyright © 2016年 李佳佳. All rights reserved.
//

#import "JECalourseCell.h"



@implementation JECalourseCell

-(instancetype)init
{
    if (self = [super init]) {
        UIImageView* imageView=[[UIImageView alloc]init];
        [imageView.layer setCornerRadius:6.0f];
        [imageView.layer setMasksToBounds:YES];
        [self addSubview:imageView];
        _imageView=imageView;
    }
    return self;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_imageView setFrame:self.bounds];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
