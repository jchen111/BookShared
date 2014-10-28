//
//  MineViewController.m
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import "MineViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>
#import "EditOfferedBookViewController.h"
#import "AppDelegate.h"
@interface MineViewController (){
    NSString *like_UDID;
    NSString *macaddress;
    
    PFObject *MarkedBook;
    
    PFQuery *markedBook;
    PFObject *OfferedBook;
    PFFile *imageFile;
    PFQuery *query;
    //PFQueryTableViewController *child;
}

@end

@implementation MineViewController

@synthesize SideBarMenuButton,Marked,Offered,TableView;





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSString *) identifierForVendor1
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    return @"";
}


- (void) retrievingDataFromParse{
    
    
    
    if(self.segmentcontrol.selectedSegmentIndex == 0){
        
        query = [PFQuery queryWithClassName:@"MarkedBook"];
        
        [query whereKey:@"macaddress" equalTo:macaddress];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"%@",macaddress);
                NSLog(@"Successfully retrieved %d data.", objects.count);
                
                if (Marked!= NULL) {
                    [Marked removeAllObjects];
                }
                
                for (PFObject *object in objects) {
                    
                    NSLog(@"%@",object.objectId);
                    [Marked addObject:object];
                    NSLog(@"%@",Marked);
                    [self.TableView reloadData];
                    
                }
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
            
        }];
    }
    
    if(self.segmentcontrol.selectedSegmentIndex == 1){
        query = [PFQuery queryWithClassName:@"PublicBookPost"];
        
        
        [query whereKey:@"macaddress" equalTo:macaddress];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"%@",macaddress);
                NSLog(@"Successfully retrieved %d data.", objects.count);
                
                if (Offered!= NULL) {
                    [Offered removeAllObjects];
                }
                
                for (PFObject *object in objects) {
                    
                    NSLog(@"%@",object.objectId);
                    [Offered addObject:object];
                    [self.TableView reloadData];
                }
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
            
        }];
        
        
    }
}

- (void)viewDidLoad
{
    
    like_UDID=[NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    macaddress = [like_UDID substringFromIndex:33];
    NSLog(@"%@",macaddress);
    self.Marked = [NSMutableArray array];
    self.Offered = [NSMutableArray array];
    [self retrievingDataFromParse];
    
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barTintColor = colorchange(127,191,212,0.9);
    self.segmentcontrol.backgroundColor=colorchange(255, 255, 255, 1);
    UILabel *label=[[UILabel alloc]init];
    label.text=@"Mine";
    label.textColor=colorchange(255, 255, 255, 1);
    label.backgroundColor=[UIColor clearColor];
    label.font = [UIFont fontWithName:@"Avenir-Light" size:32.0];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.segmentcontrol.selectedSegmentIndex = 0;
    SideBarMenuButton.target = self.revealViewController;
    SideBarMenuButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationItem.backBarButtonItem.tintColor=colorchange(127,191,212,0.9);
   
    
    self.navigationController.toolbarHidden=YES;
    
    
    
    [super viewDidLoad];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.segmentcontrol.selectedSegmentIndex == 0){
        NSLog(@"%lu",(unsigned long)Marked.count);
        return Marked.count;
    }
    else{
        NSLog(@"%lu",(unsigned long)Offered.count);
        return Offered.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarkedBookCell" forIndexPath:indexPath];
    
    [tableView setSeparatorColor:colorchange(200, 200, 200, 1)];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    cell.backgroundColor=colorchange(242, 242, 242, 1);

    if(self.segmentcontrol.selectedSegmentIndex == 0)
    {
        
        cell.textLabel.text = [[Marked objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$ %@",[[Marked objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.detailTextLabel.font=[UIFont fontWithName:@"MuseoSlab-500" size:26];
        cell.textLabel.font=[UIFont fontWithName:@"AlternateGotNo3D" size:30];
        UIImageView *CellImageView = (UIImageView*)[[cell contentView] viewWithTag:1];
        
        PFFile *imageFile;
        imageFile = [[Marked objectAtIndex:indexPath.row] objectForKey:@"bookcover"];
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
        //[self.TableView reloadData];
        
    }
    
    if (self.segmentcontrol.selectedSegmentIndex == 1)
    {
        cell.textLabel.text = [[Offered objectAtIndex:indexPath.row] objectForKey:@"title"];;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"$: %@",[[Offered objectAtIndex:indexPath.row] objectForKey:@"price"]];
        cell.detailTextLabel.font=[UIFont fontWithName:@"MuseoSlab-500" size:26];
        cell.textLabel.font=[UIFont fontWithName:@"AlternateGotNo3D" size:30];
        UIImageView *CellImageView = (UIImageView*)[[cell contentView] viewWithTag:1];
        
        PFFile *imageFile;
        imageFile = [[Offered objectAtIndex:indexPath.row] objectForKey:@"bookcover"];
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
        
    }
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"fromMineToEdit"]) {
        
        if (self.segmentcontrol.selectedSegmentIndex == 0) {
            NSIndexPath *indexPath = [self.TableView indexPathForSelectedRow];
            PFObject *object = [self.Marked objectAtIndex:indexPath.row];
            [[segue destinationViewController] setMacaddress:macaddress];
            [[segue destinationViewController] setDetailItem:object];
            [[segue destinationViewController] setObjectId:object.objectId];
            [[segue destinationViewController] setMark:YES];
            [[segue destinationViewController] setOffer:NO];
        }
        
        if (self.segmentcontrol.selectedSegmentIndex == 1) {
            NSIndexPath *indexPath = [self.TableView indexPathForSelectedRow];
            PFObject *object = [self.Offered objectAtIndex:indexPath.row];
            [[segue destinationViewController] setMacaddress:macaddress];
            [[segue destinationViewController] setDetailItem:object];
            [[segue destinationViewController] setObjectId:object.objectId];
            [[segue destinationViewController] setOffer:YES];
            [[segue destinationViewController] setMark:NO];
        }
        
    }
    
}


- (void)segmentedControlChanged:(id)sender {
    
    //    [Marked removeAllObjects];
    //    [Offered removeAllObjects];
    [self.TableView reloadData];
    [self retrievingDataFromParse];
    
}
@end
