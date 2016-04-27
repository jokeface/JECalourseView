//
//  JECalourseView.h
//  图片轮播
//
//  Created by 李佳佳 on 16/4/25.
//  Copyright © 2016年 李佳佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JECalourseCell.h"
@protocol JECalourseViewDataSource <NSObject>

@required
-(void)JE3DCalourseViewWith:(JECalourseCell*)Cell andIndex:(NSInteger)index;
-(NSInteger)JE3DCalourseNumber;
@end


@interface JECalourseView : UIView
@property(nonatomic,assign)CGFloat scaleFloat;
@property(nonatomic,assign)CGFloat margin;
@property(nonatomic,weak)id<JECalourseViewDataSource>DataSource;

-(void)animationChange;
@end
