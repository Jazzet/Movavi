//
//  ViewController.h
//  MovaviTest
//
//  Created by Jazzet on 07.10.2018.
//  Copyright © 2018 Jazzet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) BOOL noMoreResults;
@property (nonatomic) BOOL loading;

@end

