//
//  ViewController.m
//  MovaviTest
//
//  Created by Jazzet on 07.10.2018.
//  Copyright © 2018 Jazzet. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
#import "TableViewCell.h"

@interface ViewController (){
    NSXMLParser *parser;
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *description;
    NSMutableString *pubDate;
    NSMutableString *image;
    NSString *currentElement;
    NSInteger totalEntries;
}

@end

@implementation ViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    totalEntries = 10;
    self.noMoreResults =NO;
    self.dataArray =[[NSMutableArray alloc] init];
    feeds = [[NSMutableArray alloc] init];
    self.tableView.rowHeight = 210;
    
    NSArray *rssArray = @[@"https://habr.com/rss/hubs/all/", @"https://meduza.io/rss/podcasts/meduza-v-kurse"];
    for (NSString *stringWithUrl in rssArray)
    {
        NSURL *url = [NSURL URLWithString:stringWithUrl];
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setShouldResolveExternalEntities:NO];
        [parser setDelegate:self];
        [parser parse];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return totalEntries;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (totalEntries != 0) {
        if(indexPath.row < [feeds count]){
            
            cell.previewDescription.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSString *test = [[self->feeds objectAtIndex:indexPath.row] objectForKey: @"image"];
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: test]];
                if (imageData == nil)
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.previewImage.image = [UIImage imageWithData: imageData];
                });
            });
        }
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.loading) {
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height)
        {
            for (int i=1; i<=10; i++) {
                if (totalEntries == feeds.count) {
                    self.loading = YES;
                    self.noMoreResults = YES;
                    break;
                }
                totalEntries++;
            }
            [self.tableView reloadData];
            
            if ((totalEntries >= feeds.count)) {
                self.loading = YES;
                self.noMoreResults = YES;
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    currentElement = elementName;
    if ([currentElement isEqualToString:@"item"]) {
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        description    = [[NSMutableString alloc] init];
        pubDate    = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([currentElement isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([currentElement isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([currentElement isEqualToString:@"description"]) {
        [description appendString:string];
    } else if ([currentElement isEqualToString:@"pubDate"]) {
        [pubDate appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:description forKey:@"description"];
        [item setObject:pubDate forKey:@"pubDate"];
        
        [feeds addObject:[item copy]];
    }
    
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:TRUE];
    [feeds sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *fullText = [feeds[indexPath.row] objectForKey: @"description"];
        NSString *link = [feeds[indexPath.row] objectForKey: @"link"];
        NSString *title = [feeds[indexPath.row] objectForKey: @"title"];
        [[segue destinationViewController] setTextContainer:fullText];
        [[segue destinationViewController] setUrl:link];
        [[segue destinationViewController] setTitleContainer:title];
    }
}

@end
