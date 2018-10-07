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
    NSString *element;
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
    NSURL *url = [NSURL URLWithString:@"https://meduza.io/rss/podcasts/meduza-v-kurse"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    self.tableView.rowHeight = 210;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return totalEntries;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (totalEntries != 0) {
        if(indexPath.row <[feeds count]){
            cell.previewDescription.text = [[feeds objectAtIndex:indexPath.row] objectForKey: @"title"];
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
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        description    = [[NSMutableString alloc] init];
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        [item setObject:title forKey:@"title"];
        [item setObject:link forKey:@"link"];
        [item setObject:description forKey:@"description"];
        
        [feeds addObject:[item copy]];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSLog(@"%@", element);
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
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
