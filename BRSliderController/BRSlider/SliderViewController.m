//
//  SliderViewController.m
//  BRSliderViewController
//
//  Created by gitBurning on 15/3/9.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "SliderViewController.h"
#define kIndexCell @"SliderCollectionViewCell"
#import "SliderCollectionViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SliderViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>


@property(assign,nonatomic) CGFloat topWidth;

@property(strong,nonatomic) UIScrollView * sliderView;

@property(assign,nonatomic) CGFloat offSet;
@end

@implementation SliderViewController
- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _viewControllers = [viewControllers copy];
        
        self.selectIndex=0;
        
       // _selectedIndex = NSNotFound;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.offSet=64;
    
    self.topWidth=80;

    if (self.titileArray.count<4) {
        self.topWidth=kScreenWidth/self.titileArray.count;
    }
    if (_isNeedCustomWidth) {
        self.topWidth=100;
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;
    flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    self.colletionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0,self.offSet,kScreenWidth,kTopViewHeight) collectionViewLayout:flowLayout];
    
    self.colletionView.delegate=self;
    self.colletionView.dataSource=self;
    
    self.colletionView.showsHorizontalScrollIndicator=NO;
    UINib *nib=[UINib nibWithNibName:kIndexCell bundle:nil];
    
    [self.colletionView registerNib: nib forCellWithReuseIdentifier:kIndexCell];
    
    
    UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colletionView.frame)-0.5, kScreenWidth, 0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
    [self.view addSubview:self.colletionView];
    
    float height_line=INDICATOR_HEIGHT;
    if (self.lineHeight>0) {
        height_line=self.lineHeight;
    }
    CGRect frame = CGRectMake(self.indicatorInsets.left, kTopViewHeight-height_line+0.5, self.topWidth,height_line);
    _indicator = [[UIView alloc] initWithFrame:frame];
    _indicator.backgroundColor=self.selectColor;
    [self.colletionView addSubview:self.indicator];
    
    
    self.colletionView.backgroundColor=[UIColor clearColor];
    
    self.sliderView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.colletionView.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(self.colletionView.frame))];
    self.sliderView.backgroundColor=[UIColor greenColor];
    [self.view addSubview:_sliderView];
    
    
    [self.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[UIViewController class]]) {
            UIViewController * vc=obj;
            CGRect newFrame=vc.view.frame;
            newFrame.size.height=CGRectGetHeight(self.sliderView.frame);
            newFrame.origin.x+=idx*CGRectGetWidth(self.sliderView.frame);
            newFrame.origin.y=0;
            vc.view.frame=newFrame;
           // vc.view.backgroundColor=[UIColor grayColor];
            [self.sliderView addSubview:vc.view];
            
        }
    }];
    
    self.sliderView.delegate=self;
    self.sliderView.pagingEnabled=YES;
    self.sliderView.bounces=NO;
    self.sliderView.contentSize=CGSizeMake(CGRectGetWidth(self.sliderView.frame)*self.viewControllers.count, CGRectGetHeight(self.sliderView.frame));
    self.sliderView.showsHorizontalScrollIndicator=NO;
    
    if (self.selectIndex>0) {
        
        [self silderWithIndex:self.selectIndex isNeedScroller:NO];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setSelectColor:(UIColor *)selectColor{
    _selectColor=selectColor;
    
    
}

#pragma mark---顶部的滑动试图
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // return allSpaces.count;
    return self.titileArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    [self silderWithIndex:indexPath.row isNeedScroller:NO];
    
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SliderCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kIndexCell forIndexPath:indexPath];
    UILabel * line=[[UILabel alloc] initWithFrame:CGRectMake(self.topWidth-0.5, 0,0.5 ,CGRectGetHeight(cell.frame)-0.5)];
    line.backgroundColor=[UIColor lightGrayColor];
    
    if (!_isNeedCustomWidth) {
        [cell insertSubview:line atIndex:cell.subviews.count-1];

    }
  
    cell.titile.text=self.titileArray[indexPath.row];
    
    if (self.selectIndex==indexPath.row) {
        cell.titile.textColor=self.selectColor;
    }
    else{
        cell.titile.textColor=[UIColor blackColor];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(_topWidth, 44);
}


-(void)silderWithIndex:(NSInteger)index isNeedScroller:(BOOL)isNeed{
    
    //[self.view endEditing:YES];
    
  
    self.selectIndex=index;
    
    [UIView animateWithDuration:0.1*(abs((int)(self.selectIndex-index))) animations:^{
        CGRect newframe=self.indicator.frame;
        newframe.origin.x=self.topWidth*index;
        self.indicator.frame=newframe;
        
    }];
    
    if (isNeed) {
       [self.colletionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    else{
        [self.sliderView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];

    }
    
    
    
    [self.colletionView reloadData];
    
    
    if (self.sliderDelegate) {
        [self.sliderDelegate sliderScrollerDidIndex:index andSlider:self];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.sliderView]) {
        NSInteger index=scrollView.contentOffset.x/kScreenWidth;
        
        if (index!=self.selectIndex) {
            [self silderWithIndex:index isNeedScroller:YES];
        }
    }
}
-(id)getSelectSlider{
    return self.viewControllers[self.selectIndex];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
