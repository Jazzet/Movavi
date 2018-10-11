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

    NSAttributedString * attrString = [[NSAttributedString alloc] initWithData:[_textContainer dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    self.detailViewText.attributedText = attrString;
    self.titleExtend.text = _titleContainer;
    [_button addTarget:self
               action:@selector(openUrl)
     forControlEvents:UIControlEventTouchUpInside];
}

- (void) openUrl {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_url] options:@{} completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
