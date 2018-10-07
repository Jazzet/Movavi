//
//  DetailViewController.m
//  MovaviTest
//
//  Created by Jazzet on 08.10.2018.
//  Copyright © 2018 Jazzet. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIButton *button;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailViewText.text = _textContainer;
    self.titleExtend.text = _titleContainer;
    [_button addTarget:self
               action:@selector(openUrl1)
     forControlEvents:UIControlEventTouchUpInside];
}

- (void) openUrl1 {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url] options:@{} completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
