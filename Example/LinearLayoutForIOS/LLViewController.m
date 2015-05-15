//
//  LLViewController.m
//  LinearLayoutForIOS
//
//  Created by Dominik Plíšek on 05/15/2015.
//  Copyright (c) 2014 Dominik Plíšek. All rights reserved.
//

#import "LLViewController.h"
#import <LinearLayoutForIOS/LinearLayoutForIOS-Swift.h>

@interface LLViewController ()
@property (weak, nonatomic) IBOutlet VerticalLinearLayoutView *outerLayout;
@end

@implementation LLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.outerLayout.spacing = 10;
    
    UILabel *leftLabelInHorizontalLayout = [[UILabel alloc] init];
    leftLabelInHorizontalLayout.textAlignment = NSTextAlignmentLeft;
    leftLabelInHorizontalLayout.text = @"Left";
    
    UILabel *rightLabelInHorizontalLayout = [[UILabel alloc] init];
    rightLabelInHorizontalLayout.textAlignment = NSTextAlignmentRight;
    rightLabelInHorizontalLayout.text = @"Right";
    
    LinearLayoutView *horizontalLayout = [[HorizontalLinearLayoutView alloc] init];
    [horizontalLayout addMember:leftLabelInHorizontalLayout];
    [horizontalLayout addMember:rightLabelInHorizontalLayout];
    [horizontalLayout setSizeOfMemberAtPosition:0 relativeToLayout:YES size:0.5];
    [horizontalLayout setSizeOfMemberAtPosition:1 relativeToLayout:YES size:0.5];
    
    UILabel *intrinsicSizeLabel = [[UILabel alloc] init];
    intrinsicSizeLabel.text = @"Intrinsic height";

    UILabel *fixedSizeLabel = [[UILabel alloc] init];
    fixedSizeLabel.text = @"Fixed height 30";
    
    UILabel *relativeSizeLabel = [[UILabel alloc] init];
    relativeSizeLabel.text = @"Relative height 0.5";
    
    [self.outerLayout addMember:horizontalLayout];
    [self.outerLayout addMember:intrinsicSizeLabel];
    [self.outerLayout addMember:fixedSizeLabel];
    [self.outerLayout addMember:relativeSizeLabel];
    
    [self.outerLayout setSizeOfMemberAtPosition:2 relativeToLayout:NO size:30];
    [self.outerLayout setSizeOfMemberAtPosition:3 relativeToLayout:YES size:0.5];
}
@end
