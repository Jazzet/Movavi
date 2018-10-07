//
//  TableViewCell.h
//  MovaviTest
//
//  Created by Jazzet on 08.10.2018.
//  Copyright © 2018 Jazzet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *previewDescription;
@property (strong, nonatomic) IBOutlet UIImageView *previewImage;

@end

