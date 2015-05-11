//
//  ViewController.m
//  BRSliderController
//
//  Created by gitBurning on 15/3/30.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "ViewController.h"
#import "SliderViewController.h"
@interface ViewController ()<sliderScrollerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)push:(id)sender {
    NSMutableArray * array=[NSMutableArray array];
    
    NSArray * titiles=@[@"1",@"2",@"3",@"4",@"5"];
    for (int i=0; i<titiles.count; i++) {
        UIViewController * nex=[[UIViewController alloc] init];
        
        switch (i) {
            case 0:
                nex.view.backgroundColor=[UIColor grayColor];
                break;
            case 1:
                nex.view.backgroundColor=[UIColor lightGrayColor];
                break;
            case 2:
                nex.view.backgroundColor=[UIColor blueColor];
                break;
            case 3:
                nex.view.backgroundColor=[UIColor brownColor];
                break;
            case 4:
                nex.view.backgroundColor=[UIColor greenColor];
                break;
                
            default:
                break;
        }
        [array addObject:nex];
    }
    
    
    SliderViewController * next=[[SliderViewController alloc] initWithViewControllers:array];
    next.titileArray=titiles;
    next.lineHeight=2;
    next.selectColor=[UIColor greenColor];
    next.selectIndex=3;
    next.sliderDelegate=self;
    [self.navigationController pushViewController:next animated:YES];

}
-(void)sliderScrollerDidIndex:(NSInteger)index andSlider:(SliderViewController *)slider{
    
    NSString * tiitle=slider.titileArray[index];
    slider.title=tiitle;
}

@end
