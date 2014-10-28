//
//  SearchLocationViewController.m
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import "SearchLocationViewController.h"
#import "PostBookViewController.h"
#import "AppDelegate.h"
@interface SearchLocationViewController ()

@end

@implementation SearchLocationViewController{
    PFQuery *query;
}
@synthesize searchBar,searchResults,Macaddress,ISBN,title,subtitle,author;

//resize the image
-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.className = @"Locatioin";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    query = [PFQuery queryWithClassName:self.className];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UISearchBar *searchBar=[[UISearchBar alloc]init];
    self.searchBar.frame=CGRectMake(0, 0, self.view.bounds.size.width+20, 0);
    self.searchBar.delegate=self;
    self.searchBar.keyboardType=UIKeyboardTypeDefault;
    self.searchBar.showsCancelButton=YES;
    self.searchBar.showsSearchResultsButton=YES;
    self.searchBar.translucent=YES;
    self.searchBar.barStyle=UIBarStyleDefault;
    self.searchBar.placeholder=@"input";
    //searchBar.prompt=@"search";
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView=self.searchBar;
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [searchResults count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    cell.textLabel.text=[[searchResults objectAtIndex:indexPath.row] objectForKey:@"College"];
    cell.detailTextLabel.text = [[searchResults objectAtIndex:indexPath.row]objectForKey:@"Campus"];
    [tableView setSeparatorColor:colorchange(200, 200, 200, 1)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    cell.backgroundColor=colorchange(242, 242, 242, 1);
    cell.detailTextLabel.font=[UIFont fontWithName:@"MuseoSlab-500" size:24];
    cell.textLabel.font=[UIFont fontWithName:@"AlternateGotNo3D" size:26];
    if (searchResults.count==0) {
        cell.textLabel.text=@"Sorry, we didn't see and matched book";
    }
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{[searchResults removeAllObjects];
  [self.searchBar resignFirstResponder];
  searchResults = [NSMutableArray arrayWithCapacity:10];
  query = [PFQuery queryWithClassName:@"Location"];
  
  
  [query whereKey:@"College" containsString:[self.searchBar.text uppercaseString]];
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
        // The find succeeded.
        NSLog(@"Successfully retrieved %d data.", objects.count);
        
        for (PFObject *object in objects) {
            
            NSLog(@"%@",object.objectId);
            [searchResults addObject:object];
            NSLog(@"%@",searchResults);
            [self loadObjects];
            
            [self.tableView reloadData];
            
        }
        
    } else {
        // Log details of the failure
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    
    
}];
  [self loadObjects];
  [self.tableView reloadData];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text=@" ";
    [self.searchBar resignFirstResponder];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (0==searchText.length) {
        return;
    }
    searchResults = [NSMutableArray arrayWithCapacity:10];
    query = [PFQuery queryWithClassName:@"Location"];
    
    
    [query whereKey:@"College" containsString:[self.searchBar.text uppercaseString]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d data.", objects.count);
            
            for (PFObject *object in objects) {
                
                NSLog(@"%@",object.objectId);
                [searchResults addObject:object];
                NSLog(@"%@",searchResults);
                [self loadObjects];
                
                [self.tableView reloadData];
                
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
    }];
//    [self loadObjects];
//    [self.tableView reloadData];
    
//    [searchResults removeAllObjects];
//    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"backtopost"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [searchResults objectAtIndex:indexPath.row];
        //[[segue destinationViewController] setMacaddress:macaddress];
        NSString *college = [object objectForKey:@"College"];
        NSString *campus = [object objectForKey:@"Campus"];
        NSString *location = [[college stringByAppendingString:@" "] stringByAppendingString:campus];
        
        [[segue destinationViewController] setCampusLocatioin:location];
        [[segue destinationViewController] setMacaddress:Macaddress];
        [[segue destinationViewController] setISBN:ISBN];
        [[segue destinationViewController] setBooktitle:title];
        [[segue destinationViewController] setSubtitle:subtitle];
        [[segue destinationViewController] setAuthor:author];
    }
}

@end
