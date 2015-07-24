//
//  LLViewController.m
//  LinearLayoutForIOS
//
//  Created by Dominik Plíšek on 05/15/2015.
//  Copyright (c) 2014 Dominik Plíšek. All rights reserved.
//

#import "LLViewController.h"
#import <LinearLayoutForIOS/LinearLayoutForIOS-Swift.h>

#define BUTTON_COUNT    2

@interface LLViewController ()
@property (weak, nonatomic) IBOutlet VerticalLinearLayoutView *outerLayout;
@property (nonatomic, strong) HorizontalLinearLayoutView *innerLayout;
@end

@implementation LLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *leftLabelInHorizontalLayout = [[UILabel alloc] init];
    leftLabelInHorizontalLayout.textAlignment = NSTextAlignmentLeft;
    leftLabelInHorizontalLayout.text = @"Left";
    
    UILabel *rightLabelInHorizontalLayout = [[UILabel alloc] init];
    rightLabelInHorizontalLayout.textAlignment = NSTextAlignmentRight;
    rightLabelInHorizontalLayout.text = @"Right";
    
    self.innerLayout = [[HorizontalLinearLayoutView alloc] init];
    [self.innerLayout addMember:leftLabelInHorizontalLayout];
    [self.innerLayout addMember:rightLabelInHorizontalLayout];
    [self.innerLayout setSizeOfMemberAtPosition:0 relativeToLayout:YES size:0.5];
    [self.innerLayout setSizeOfMemberAtPosition:1 relativeToLayout:YES size:0.5];
    
    UILabel *intrinsicSizeLabel = [[UILabel alloc] init];
    intrinsicSizeLabel.text = @"Intrinsic height";

    UILabel *fixedSizeLabel = [[UILabel alloc] init];
    fixedSizeLabel.text = @"Fixed height 30";
    
    UILabel *relativeSizeLabel = [[UILabel alloc] init];
    relativeSizeLabel.text = @"Relative height 0.5";
    
    UIButton *removeSomething = [[UIButton alloc] init];
    [removeSomething setTitle:@"Remove random" forState:UIControlStateNormal];
    [removeSomething setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [removeSomething addTarget:self action:@selector(removeRandomMember) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeMargins = [[UIButton alloc] init];
    [changeMargins setTitle:@"Change margins" forState:UIControlStateNormal];
    [changeMargins setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeMargins addTarget:self action:@selector(changeGeometry) forControlEvents:UIControlEventTouchUpInside];
    
    [self.outerLayout addMember:self.innerLayout];
    [self.outerLayout addMember:intrinsicSizeLabel];
    [self.outerLayout addMember:fixedSizeLabel];
    [self.outerLayout addMember:relativeSizeLabel];
    [self.outerLayout addMember:removeSomething];
    [self.outerLayout addMember:changeMargins];
    
    [self.outerLayout setSizeOfMemberAtPosition:2 relativeToLayout:NO size:30];
    [self.outerLayout setSizeOfMemberAtPosition:3 relativeToLayout:YES size:0.5];
}

- (void)removeRandomMember
{
    if (self.outerLayout.memberCount == BUTTON_COUNT) return;
    NSUInteger randomMemberIdxWithoutButton = arc4random() % (self.outerLayout.memberCount - BUTTON_COUNT);
    [self.outerLayout removeMemberAtPosition:randomMemberIdxWithoutButton];
}

- (void)changeGeometry
{
    self.outerLayout.leadingMargin = arc4random() % 20;
    self.outerLayout.leadingSideMargin = arc4random() % 10;
    self.outerLayout.trailingSideMargin = arc4random() % 10;
    self.outerLayout.spacing = arc4random() % 15;

    self.innerLayout.leadingMargin = arc4random() % 20;
    self.innerLayout.leadingSideMargin = arc4random() % 10;
    self.innerLayout.trailingSideMargin = arc4random() % 10;
    self.innerLayout.spacing = arc4random() % 15;
}

@end
