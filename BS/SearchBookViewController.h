//
//  SearchBookViewController.h
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchBookViewController : PFQueryTableViewController <UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)UISearchDisplayController *searchController;
@property (strong) NSString *className;
@property (strong) NSString *Macaddress;

@end
