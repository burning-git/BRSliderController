//
//  SliderViewController.h
//  BRSliderViewController
//
//  Created by gitBurning on 15/3/9.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INDICATOR_HEIGHT 3
#define kTopViewHeight 44

@class SliderViewController;
@protocol sliderScrollerDelegate <NSObject>

-(void)sliderScrollerDidIndex:(NSInteger)index andSlider:(SliderViewController*)slider;

@end

@interface SliderViewController : UIViewController
@property(strong,nonatomic)  UICollectionView * colletionView;
@property(strong,nonatomic)   NSArray * titileArray;
@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, assign) UIEdgeInsets indicatorInsets;
@property(assign,nonatomic) NSInteger selectIndex;

@property(assign,nonatomic) id<sliderScrollerDelegate>sliderDelegate;
@property(assign,nonatomic) BOOL isNeedCustomWidth;
-(void)silderWithIndex:(NSInteger)index isNeedScroller:(BOOL)isNeed;
/**
 *  设置点中的颜色
 */
@property(strong,nonatomic) UIColor * selectColor;
@property(strong,nonatomic) NSArray *viewControllers;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;


-(id)getSelectSlider;

@end
