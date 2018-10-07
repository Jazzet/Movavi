//
//  DetailViewController.h
//  MovaviTest
//
//  Created by Jazzet on 08.10.2018.
//  Copyright © 2018 Jazzet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSString *textContainer;
@property (strong, nonatomic) NSString *titleContainer;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UILabel *detailViewText;
@property (strong, nonatomic) IBOutlet UILabel *titleExtend;


@end
