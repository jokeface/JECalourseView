//
//  JECalourseView.m
//  图片轮播
//
//  Created by 李佳佳 on 16/4/25.
//  Copyright © 2016年 李佳佳. All rights reserved.
//

#import "JECalourseView.h"
#import "JECalourseCell.h"

@interface JECalourseView ()


@property(strong,nonatomic)JECalourseCell* view1;
@property(strong,nonatomic)JECalourseCell* view2;
@property(strong,nonatomic)JECalourseCell* view3;
@property(strong,nonatomic)UIPanGestureRecognizer* pan;
@property(strong,nonatomic)UITapGestureRecognizer* tap;

@property(nonatomic,assign)CGPoint TempOriPostOne;
@property(nonatomic,assign)CGPoint TempOriPostTwo;
@property(nonatomic,assign)CGPoint TempOriPostThree;
@property(nonatomic,assign)CGFloat singlex;
@property(nonatomic,assign)NSInteger totalCount;
@property(nonatomic,assign)BOOL Touch;

@property(nonatomic,assign)CATransform3D transOriOne;
@property(nonatomic,assign)CATransform3D transOriTwo;
@property(nonatomic,assign)CATransform3D transOriThree;

@property(nonatomic,assign)CGRect TempOriFrame;
@property(strong,nonatomic)NSTimer* timer;
@property(strong,nonatomic)UIView* containerView;
@end

@implementation JECalourseView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        _scaleFloat=0.25;
        _margin=10;
//        [self addSubviews];
        
//        [self setBackgroundColor:[UIColor blueColor]];
    }
    return self;
}
//-(void)addSubviews
//{
//    JECalourseCell* view1=[[JECalourseCell alloc]initWithFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
//    [view1 setBackgroundColor:[UIColor redColor]];
//    
//    _view1=view1;
//    
//    JECalourseCell* view2=[[JECalourseCell alloc]initWithFrame:CGRectMake(self.bounds.size.width-_margin,0 , self.bounds.size.width, self.bounds.size.height)];
//    
//    [view2 setBackgroundColor:[UIColor greenColor]];
//    _view2=view2;
//    
//    
//    JECalourseCell* view3=[[JECalourseCell alloc]initWithFrame:CGRectMake(-self.bounds.size.width+_margin, 0, self.bounds.size.width, self.bounds.size.height)];
//    [view3 setBackgroundColor:[UIColor purpleColor]];
//    _view3=view3;
//    
//}
-(void)setDataSource:(id<JECalourseViewDataSource>)DataSource
{
    _DataSource=DataSource;
    
    self.totalCount=[_DataSource JE3DCalourseNumber];
    JECalourseCell* view1 = [[JECalourseCell alloc]init];
    view1.sectionTag=1;
    [view1 setFrame:CGRectMake(0,0, self.bounds.size.width, self.bounds.size.height)];
    [_DataSource JE3DCalourseViewWith:view1 andIndex:0];
    
    
    _view1=view1;
    
    JECalourseCell* view2 = [[JECalourseCell alloc]init];
    view2.sectionTag=1;
    [view2 setFrame:CGRectMake(self.bounds.size.width-_margin,0 , self.bounds.size.width, self.bounds.size.height)];
    
    [_DataSource JE3DCalourseViewWith:view2 andIndex:1];
    _view2=view2;
    
    
    JECalourseCell* view3 = [[JECalourseCell alloc]init];
    view3.sectionTag=_totalCount-1;
    [view3 setFrame:CGRectMake(-self.bounds.size.width+_margin, 0, self.bounds.size.width, self.bounds.size.height)];
    
    [_DataSource JE3DCalourseViewWith:view3 andIndex:_totalCount-1];
    _view3=view3;
    
    [self addSubview:_view1];
    [self addSubview:_view2];
    [self addSubview:_view3];
    
    [self animationChange];
    [self updateTag];
    _transOriOne=_view1.layer.transform;
    _transOriTwo=_view2.layer.transform;
    _transOriThree=_view3.layer.transform;
    _TempOriPostOne=_view1.layer.position;
    _TempOriPostTwo=_view2.layer.position;
    _TempOriPostThree=_view3.layer.position;
    
    
    _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handelPan:)];
    _tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Tap:)];
    [self addGestureRecognizer:_pan];
    [self addGestureRecognizer:_tap];
    _timer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerChange) userInfo:nil repeats:YES];
    
}
-(void)updateTag
{
    _view1.tag=0;
    _view2.tag=1;
    _view3.tag=2;
}
-(void)timerChange
{
    
    if (_Touch) {
        [_timer setFireDate:[NSDate distantFuture]];
        double delayInSeconds = 8.0f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_timer setFireDate:[NSDate distantPast]];
        });
        return;
    }
    
    JECalourseCell* tempView=_view3;
    _view3=_view1;
    _view1=_view2;
    _view2=tempView;
    

    [self updateTag];
    [self animationChange];
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _view2.sectionTag=[self NextNumberAfter:_view1.sectionTag];
        [self.DataSource JE3DCalourseViewWith:_view2 andIndex:_view2.sectionTag];
    });
    
    [self AnmiationChangeWithUIView:_view1 andPosition:_TempOriPostOne];
    [self AnmiationChangeWithUIView:_view2 andPosition:_TempOriPostTwo];
    [self AnmiationChangeWithUIView:_view3 andPosition:_TempOriPostThree];
}
-(NSInteger)NextNumberAfter:(NSInteger)index
{
    if (index==_totalCount-1) {
        return 0;
    }
    return index+1;
}
-(NSInteger)BeforeNumberAfter:(NSInteger)index
{
    if (index==0) {
        return _totalCount-1;
    }
    return index-1;
}

-(void)Tap:(UITapGestureRecognizer*)gesture
{
    NSLog(@"%ld",(long)_view1.sectionTag);
}
-(void)handelPan:(UIPanGestureRecognizer*)gestureRecognizer{
    CGPoint transPoint=[gestureRecognizer translationInView:self];
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
        _Touch=YES;
        
//        [_timer setFireDate:[NSDate distantFuture]];
    }else if (gestureRecognizer.state==UIGestureRecognizerStateChanged) {
        
        
             _view1.layer.position=CGPointMake(_TempOriPostOne.x+transPoint.x, _view1.layer.position.y);
             _view2.layer.position=CGPointMake(_TempOriPostTwo.x+transPoint.x, _view2.layer.position.y);
             _view3.layer.position=CGPointMake(_TempOriPostThree.x+transPoint.x, _view3.layer.position.y);
        [self animationChange];

    }else if (gestureRecognizer.state==UIGestureRecognizerStateEnded)
    {
        _Touch=NO;
        [self StopAnimationWithTransforX:transPoint.x];
        
    }
   
}
//-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    anim
//}
-(void)StopAnimationWithTransforX:(CGFloat)transX
{
    NSLog(@"%f",transX);
    if (transX<-self.bounds.size.width/2) {
        NSLog(@"向左转");
        
        JECalourseCell* tempView=_view3;
        _view3=_view1;
        _view1=_view2;
        _view2=tempView;
        
        [_view2.layer setPosition:CGPointMake(_view1.layer.position.x+self.bounds.size.width-_margin, _view2.layer.position.y)];
        [self updateTag];
        [self animationChange];
        
        _view2.sectionTag=[self NextNumberAfter:_view1.sectionTag];
        [self.DataSource JE3DCalourseViewWith:_view2 andIndex:_view2.sectionTag];
        [self AnmiationTypeTwoChangeWithUIView:_view1 andPosition:_TempOriPostOne];
        [self AnmiationTypeTwoChangeWithUIView:_view2 andPosition:_TempOriPostTwo];
        [self AnmiationTypeTwoChangeWithUIView:_view3 andPosition:_TempOriPostThree];
    }else if(transX>self.bounds.size.width/2)
    {
        JECalourseCell* tempView=_view2;
        _view2=_view1;
        _view1=_view3;
        _view3=tempView;
        
        [_view3.layer setPosition:CGPointMake(_view1.layer.position.x-self.bounds.size.width+_margin, _view3.layer.position.y)];
        _view3.sectionTag=[self BeforeNumberAfter:_view1.sectionTag];
        [self.DataSource JE3DCalourseViewWith:_view3 andIndex:_view3.sectionTag];
        [self updateTag];
        [self animationChange];
        [self AnmiationTypeTwoChangeWithUIView:_view1 andPosition:_TempOriPostOne];
        [self AnmiationTypeTwoChangeWithUIView:_view2 andPosition:_TempOriPostTwo];
        [self AnmiationTypeTwoChangeWithUIView:_view3 andPosition:_TempOriPostThree];
    }else
    {
        NSLog(@"返回远处");
        
        [self AnmiationTypeTwoChangeWithUIView:_view1 andPosition:_TempOriPostOne];
        [self AnmiationTypeTwoChangeWithUIView:_view2 andPosition:_TempOriPostTwo];
        [self AnmiationTypeTwoChangeWithUIView:_view3 andPosition:_TempOriPostThree];
        
    
        
    }
}
-(void)AnmiationTypeTwoChangeWithUIView:(UIView*)view andPosition:(CGPoint)position
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    [anim setFromValue:[NSValue valueWithCATransform3D:view.layer.transform]];
    CATransform3D trans3d=[self transFormFrom:position.x];
    [anim setToValue:[NSValue valueWithCATransform3D:trans3d]];
    //    [anim setDuration:10.0f];
    
    
    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"position"];
    
    [anim2 setFromValue:[NSValue valueWithCGPoint:view.layer.position]];
    [anim2 setToValue:[NSValue valueWithCGPoint:position]];
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.delegate=self;
    group.animations=@[anim,anim2];
    group.duration=0.5f;
    [view.layer addAnimation:group forKey:nil];
    [view.layer setTransform:trans3d];
    view.layer.position=position;

}


-(void)AnmiationChangeWithUIView:(UIView*)view andPosition:(CGPoint)position
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    [anim setFromValue:[NSValue valueWithCATransform3D:view.layer.transform]];
    CATransform3D trans3d=[self transFormFrom:position.x];
    [anim setToValue:[NSValue valueWithCATransform3D:trans3d]];
    //    [anim setDuration:10.0f];
    
    
    CAKeyframeAnimation *anim2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    NSValue* value1 =[NSValue valueWithCGPoint:view.layer.position];
    NSValue* value2;
    if (view.tag==2) {
//        NSValue* value2=
        NSLog(@"");
        value2=[NSValue valueWithCGPoint:CGPointMake((view.layer.position.x + position.x)/2-6, view.layer.position.y)];
        NSValue* value3 =[NSValue valueWithCGPoint:position];
        anim2.values=@[value1,value2,value3];
        anim2.keyTimes=@[@0.0,@0.5,@1.0];
    }else if(view.tag==0)
    {
//        [view setBackgroundColor:[UIColor blackColor]];

        value2=[NSValue valueWithCGPoint:CGPointMake((view.layer.position.x + position.x)/2+6, view.layer.position.y)];
        NSValue* value3 =[NSValue valueWithCGPoint:position];
        anim2.values=@[value1,value2,value3];
        anim2.keyTimes=@[@0.0,@0.5,@1.0];
    }else if (view.tag==1)
    {
        
        value2=[NSValue valueWithCGPoint:CGPointMake(view.layer.position.x -self.bounds.size.width/2+12, view.layer.position.y)];
        NSValue* value3=[NSValue valueWithCGPoint:CGPointMake(position.x+self.bounds.size.width/2-12, view.layer.position.y)];
        NSValue* value4 =[NSValue valueWithCGPoint:position];
        anim2.values=@[value1,value2,value3,value4];
        anim2.keyTimes=@[@0.0,@0.5,@0.5,@1.0];
    }
    
//    switch (view.tag) {
//        case 0:
//            
//            break;
//        case 1:
//            value2=[NSValue valueWithCGPoint:CGPointMake((view.layer.position.x + position.x)/2, view.layer.position.y)];
//            break;
//        default:
//            value2=[NSValue valueWithCGPoint:CGPointMake((view.layer.position.x + position.x)/2-12.5, view.layer.position.y)];
//            break;
//    }
    
    
    
    
//    [anim2 setFromValue:[NSValue valueWithCGPoint:view.layer.position]];
//    [anim2 setToValue:[NSValue valueWithCGPoint:position]];
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.delegate=self;
    group.animations=@[anim,anim2];
    group.duration=1.0f;
    [view.layer addAnimation:group forKey:nil];
    [view.layer setTransform:trans3d];
    view.layer.position=position;

//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
//    
//    [anim setFromValue:[NSValue valueWithCATransform3D:view.layer.transform]];
//    CATransform3D trans3d=[self transFormFrom:position.x];
//    [anim setToValue:[NSValue valueWithCATransform3D:trans3d]];
//    //    [anim setDuration:10.0f];
//    
//    
//    CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"position"];
//    
//    [anim2 setFromValue:[NSValue valueWithCGPoint:view.layer.position]];
//    [anim2 setToValue:[NSValue valueWithCGPoint:position]];
//    
//    CAAnimationGroup* group = [CAAnimationGroup animation];
//    group.delegate=self;
//    group.animations=@[anim,anim2];
//    group.duration=1.0f;
//    [view.layer addAnimation:group forKey:nil];
//    [view.layer setTransform:trans3d];
//    view.layer.position=position;
}



-(void)animationChange
{
    
    [self addTransform:_view1];
    [self addTransform:_view2];
    [self addTransform:_view3];

}

-(CATransform3D)transFormFrom:(CGFloat)position
{
    CGFloat chaFloat=[self positiveFloatFrom:(position-CGRectGetMidX(self.bounds))/self.bounds.size.width];
    
    
    CGFloat angel=(position-CGRectGetMidX(self.bounds))/self.bounds.size.width*M_PI/10;
    
    
    CGFloat latx;
    if (position == _TempOriPostOne.x || position == _TempOriPostTwo.x || position == _TempOriPostThree.x) {
        latx=0;
    }else
    {
        latx=(position-CGRectGetMidX(self.bounds))/self.bounds.size.width*6;
    }
    CATransform3D transformlat=CATransform3DMakeTranslation(latx, 0, 0);
    
    
    CATransform3D transformRotation = CATransform3DIdentity;
    transformRotation.m34=-1/275.0;
    transformRotation=CATransform3DRotate(transformRotation,angel, 0, 1, 0);
    
    
    //    CATransform3D transform= CATransform3DRotate(transform, angel, 0, 0.5, 0);
    CATransform3D transformScale=CATransform3DMakeScale(1-chaFloat*_scaleFloat, 1-chaFloat*_scaleFloat,1);
    
    
    return CATransform3DConcat(CATransform3DConcat(transformRotation, transformScale), transformlat);
    
}
-(void)addTransform:(UIView*)view
{
    
   view.layer.transform=[self transFormFrom:view.layer.position.x];
    
    
//    CGFloat chaFloat=[self positiveFloatFrom:(view.layer.position.x-CGRectGetMidX(self.bounds))/self.bounds.size.width];
//    
//    
//    CGFloat angel=(view.layer.position.x-CGRectGetMidX(self.bounds))/self.bounds.size.width*M_PI/10;
//    
//    
//    CATransform3D transformRotation = CATransform3DIdentity;
//    transformRotation.m34=-1/275.0;
//    transformRotation=CATransform3DRotate(transformRotation,angel, 0, 1, 0);
//    
//    
////    CATransform3D transform= CATransform3DRotate(transform, angel, 0, 0.5, 0);
//    CATransform3D transformScale=CATransform3DMakeScale(1-chaFloat*_scaleFloat, 1-chaFloat*_scaleFloat,1);
//    
//    
//    view.layer.transform=CATransform3DConcat(transformRotation, transformScale);

}
-(CGFloat)positiveFloatFrom:(CGFloat)fromFloat
{
    if (fromFloat<0) {
        return -fromFloat;
    }
    return fromFloat;
}



@end
