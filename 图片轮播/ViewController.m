//
//  ViewController.m
//  图片轮播
//
//  Created by 李佳佳 on 16/1/7.
//  Copyright © 2016年 李佳佳. All rights reserved.
//

#import "ViewController.h"
#import "JECalourseView.h"
@interface ViewController ()<JECalourseViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viewww;
@property(nonatomic,strong)JECalourseView* calourse;
//@property(strong,nonatomic)UIView* view1;
//@property(strong,nonatomic)UIView* view2;
//@property(strong,nonatomic)UIPanGestureRecognizer* pan;
//@property(nonatomic,assign)CGFloat OriCenterX;
//@property(nonatomic,assign)CGFloat TempOriCenterX;
//@property(nonatomic,assign)CGRect TempOriFrame;
//@property(strong,nonatomic)NSTimer* timer;
//@property(strong,nonatomic)UIView* containerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpViews];
    JECalourseView* calourse = [[JECalourseView alloc]initWithFrame:CGRectMake(25, 10, self.view.bounds.size.width-50, 200)];
    
    [self.view addSubview:calourse];
    [calourse setDataSource:self];
    _calourse=calourse;
    
    
    
    
}
-(NSInteger)JE3DCalourseNumber
{
    return 5;
}
-(void)JE3DCalourseViewWith:(JECalourseCell *)Cell andIndex:(NSInteger)index
{
    
    [Cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",(long)index]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
