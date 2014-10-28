//
//  SearchBookViewController.m
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import "SearchBookViewController.h"
#import "BookInfoViewController.h"
#import "AppDelegate.h"
static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";

@interface SearchBookViewController ()<UISearchDisplayDelegate,UISearchBarDelegate>{

}
@end

@implementation SearchBookViewController{
    PFQuery *queryCapitalizedString;
    PFQuery *queryLowerCaseString;
    PFQuery *querySearchBarString;
    PFQuery *finalQuery;
    PFQuery *query;
}

@synthesize searchBar;
@synthesize searchResults;
@synthesize Macaddress;


//resize the image
-(UIImage*)resizeImage:(UIImage *)image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //here is the scaled image which has been changed to the size specified
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
        self.className = @"PublicBookPost";
        
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
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barTintColor=colorchange(127,191,212,0.9);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
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
    NSString *str=@"SearchCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    cell.textLabel.text=[[searchResults objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$: %@",[[searchResults objectAtIndex:indexPath.row]objectForKey:@"price"]];
    UIImageView *CellImageView = (UIImageView*)[[cell contentView] viewWithTag:1];
    cell.frame=CGRectMake(0, 0, cell.window.frame.size.width, 167);
    [tableView setSeparatorColor:colorchange(200, 200, 200, 1)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    cell.backgroundColor=colorchange(242, 242, 242, 1);
    cell.detailTextLabel.font=[UIFont fontWithName:@"MuseoSlab-500" size:26];
    cell.textLabel.font=[UIFont fontWithName:@"AlternateGotNo3D" size:30];
    PFFile *imageFile;
    imageFile = [[searchResults objectAtIndex:indexPath.row] objectForKey:@"bookcover"];
   
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            CGSize size = CGSizeMake(80, 60);
            UIImage *resizedimage = [self resizeImage:image imageSize:size];
            CellImageView.image = resizedimage;
        }
    }];

    if (searchResults.count==0) {
        cell.textLabel.text=@"Sorry, we didn't see and matched book";
    }
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchResults removeAllObjects];
    searchResults = [NSMutableArray arrayWithCapacity:10];
    
    queryCapitalizedString = [PFQuery queryWithClassName:@"PublicBookPost"];
    [queryCapitalizedString whereKey:@"title" containsString:[self.searchBar.text capitalizedString]];
    
    queryLowerCaseString = [PFQuery queryWithClassName:@"PublicBookPost"];
    [queryLowerCaseString whereKey:@"title" containsString:[self.searchBar.text lowercaseString]];
    
    querySearchBarString = [PFQuery queryWithClassName:@"PublicBookPost"];
    [querySearchBarString whereKey:@"title" containsString:self.searchBar.text];
    
    finalQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryCapitalizedString,queryLowerCaseString, querySearchBarString,nil]];
    
    [finalQuery whereKey:@"macaddress" notEqualTo:Macaddress];
    
    [finalQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d data.", objects.count);
            
            for (PFObject *object in objects) {
                
                NSLog(@"%@",object.objectId);
                [searchResults addObject:object];
                NSLog(@"%@",searchResults);
                NSLog(@"%@",[searchResults objectAtIndex:0]);
                NSLog(@"%@",[[searchResults objectAtIndex:0] objectForKey:@"title"]);
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
    
    [searchResults removeAllObjects];
    searchResults = [NSMutableArray arrayWithCapacity:10];
    
    queryCapitalizedString = [PFQuery queryWithClassName:@"PublicBookPost"];
    [queryCapitalizedString whereKey:@"title" containsString:[self.searchBar.text capitalizedString]];
    
    queryLowerCaseString = [PFQuery queryWithClassName:@"PublicBookPost"];
    [queryLowerCaseString whereKey:@"title" containsString:[self.searchBar.text lowercaseString]];
    
    querySearchBarString = [PFQuery queryWithClassName:@"PublicBookPost"];
    [querySearchBarString whereKey:@"title" containsString:self.searchBar.text];
    
    finalQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:queryCapitalizedString,queryLowerCaseString, querySearchBarString,nil]];
    [finalQuery whereKey:@"macaddress" notEqualTo:Macaddress];
    [finalQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d data.", objects.count);
            
            for (PFObject *object in objects) {
                
                NSLog(@"%@",object.objectId);
                [searchResults addObject:object];
                NSLog(@"%@",searchResults);
                NSLog(@"%@",[searchResults objectAtIndex:0]);
                NSLog(@"%@",[[searchResults objectAtIndex:0] objectForKey:@"title"]);
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"showbookinfo"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [searchResults objectAtIndex:indexPath.row];
        [[segue destinationViewController] setMacaddress:Macaddress];
        [[segue destinationViewController] setDetailItem:object];
    }
}
@end
