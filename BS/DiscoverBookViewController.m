//
//  MasterViewController.m
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import "DiscoverBookViewController.h"

#import "BookInfoViewController.h"
#import "SWRevealViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface DiscoverBookViewController(){
    
}
@end

@implementation DiscoverBookViewController{
    NSString *like_UDID;
    NSString *macaddress;
    UINavigationController *navigationController;
}



@synthesize SideBarMenuButton;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (NSString *) identifierForVendor1
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[[UIDevice currentDevice] identifierForVendor] UUIDString] substringWithRange:NSMakeRange(33, 65)];
    }
    return @"";
}
//-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    
//    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if(self){
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectZero];
//        label=(UILabel *)self.navigationItem.titleView;
//        label.backgroundColor=[UIColor clearColor];
//        
//    }
//    return self;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
//    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//    for(indFamily=0;indFamily<[familyNames count];++indFamily)
//    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
//        for(indFont=0; indFont<[fontNames count]; ++indFont)
//        {
//            NSLog(@" Font name: %@",[fontNames objectAtIndex:indFont]);
//        }
//    }
//    NSLog(@"%@",self.view.backgroundColor);
    self.view.backgroundColor=colorchange(127,191,212,0.9);
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barTintColor = colorchange(127,191,212,0.9);
    UILabel *label=[[UILabel alloc]init];
    label.text=@"Discover";
    label.textColor=colorchange(255, 255, 255, 1);
    label.backgroundColor=[UIColor clearColor];
    label.font = [UIFont fontWithName:@"Avenir-Light" size:32.0];
    [label sizeToFit];
    self.navigationItem.titleView = label;
	// Do any additional setup after loading the view, typically from a nib.
    //Side menu button
    SideBarMenuButton.target=self.revealViewController;
    SideBarMenuButton.action=@selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationController.toolbarHidden=YES;
    //compose button & search button
    UIBarButtonItem *composeButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(clickComposeButton)];
    //composeButton.tintColor=colorchange(139,196,215,0.9);
    
    UIBarButtonItem *searchBookButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(clickSearchButton)];
    //searchBookButton.tintColor=colorchange(139,196,215,0.9);
    NSArray *buttonArray=[[NSArray alloc]initWithObjects:searchBookButton,composeButton, nil];
    self.navigationItem.rightBarButtonItems=buttonArray;
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor=colorchange(127,191,212,0.9);
    like_UDID=[NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    macaddress = [like_UDID substringFromIndex:33];
    NSLog(@"%@",macaddress);
}

-(void)clickComposeButton;
{
    [self performSegueWithIdentifier:@"gotooffer" sender:self];
}

-(void)clickSearchButton;
{
    [self performSegueWithIdentifier:@"gotosearch" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

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
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"PublicBookCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    [tableView setSeparatorColor:colorchange(200, 200, 200, 1)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    cell.backgroundColor=colorchange(242, 242, 242, 1);
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$: %@",
                                 [object objectForKey:@"price"]];
    cell.detailTextLabel.font=[UIFont fontWithName:@"MuseoSlab-500" size:26];
    cell.textLabel.font=[UIFont fontWithName:@"AlternateGotNo3D" size:30];
    cell.textLabel.frame=CGRectMake(0, 10, 48, 32);
   // cell.detailTextLabel.font=[UIFont fontWithName:@"ProximaNovaACond-RegularIt" size:20];
    UIImageView *CellImageView = (UIImageView*)[[cell contentView] viewWithTag:1];
    //cell.textLabel.font=[UIFont fontWithName:@"Age" size:26];
   // label.font = [UIFont fontWithName:@"Neutraface2Display-Titling" size:20];
    PFFile *imageFile;
    imageFile = [object objectForKey:@"bookcover"];
    //image = [UIImage imagewith];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            CGSize size = CGSizeMake(80, 60);
            UIImage *resizedimage = [self resizeImage:image imageSize:size];
            CellImageView.image = resizedimage;
        }
    }];
    
    return cell;
}


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


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        [[segue destinationViewController] setMacaddress:macaddress];
        [[segue destinationViewController] setDetailItem:object];
    }
    
    if ([[segue identifier] isEqualToString:@"gotosearch"]) {
        [[segue destinationViewController] setMacaddress:macaddress];
    }
    
    if ([[segue identifier] isEqualToString:@"gotooffer"]) {
        [[segue destinationViewController] setMacaddress:macaddress];
    }
    
    
}

@end
