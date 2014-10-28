//
//  SearchLocationViewController.h
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchLocationViewController : PFQueryTableViewController<UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong)UISearchDisplayController *searchController;
@property (strong) NSString *className;
@property (strong) NSString *Macaddress;
@property (strong) NSString *ISBN;
@property (strong) NSString *title;
@property (strong) NSString *subtitle;
@property (strong) NSString *author;


@end
