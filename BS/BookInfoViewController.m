//
//  DetailViewController.m
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import "BookInfoViewController.h"
#import "MineViewController.h"
#import "AppDelegate.h"
@interface BookInfoViewController ()
- (void)configureView;
@end

@implementation BookInfoViewController{
    PFObject *MarkedBook;
    PFFile *imageFile;
}

@synthesize Macaddress;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 524)];
    
    //self.view.backgroundColor=colorchange(139,196,215,0.9);
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barTintColor = colorchange(127,191,212,0.9);
    self.navigationController.toolbar.barTintColor=colorchange(127,191,212,0.9);
    UILabel *label=[[UILabel alloc]init];
    label.text=@"Book Info";
    label.textColor=colorchange(255, 255, 255, 1);
    label.backgroundColor=[UIColor clearColor];
    label.font = [UIFont fontWithName:@"Avenir-Light" size:32.0];
    [label sizeToFit];
    self.navigationItem.titleView = label;
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",self.detailItem);
    self.navigationController.toolbarHidden = NO;
    self.booktitle.text = [self.detailItem objectForKey:@"title"];
    self.subtitletextview.text=[self.detailItem objectForKey:@"subtitle"];
    self.authoretxt.text = [self.detailItem objectForKey:@"author"];
    self.isbntext.text=[self.detailItem objectForKey:@"ISBN"];
    self.price.text = [self.detailItem objectForKey:@"price"];
    self.price.font=[UIFont fontWithName:@"MuseoSlab-500" size:28];
    self.avalabletime.text = [self.detailItem objectForKey:@"avalabletime"];
    self.location.text = [self.detailItem objectForKey:@"location"];
    self.contact.text = [self.detailItem objectForKey:@"contact"];
    self.booktitle.font=[UIFont fontWithName:@"AlternateGotNo3D" size:28];
    self.subtitletextview.font=[UIFont fontWithName:@"ProximaNovaCond-RegularIt" size:16];
    self.authoretxt.font=[UIFont fontWithName:@"ProximaNovaCond-Regular" size:16];
    self.authoretxt .tintColor=colorchange(85, 85, 85, 1.0);
    self.isbnlabel.font=[UIFont fontWithName:@"ProximaNovaCond-Regular" size:16];
    self.isbntext.font=[UIFont fontWithName:@"ProximaNovaCond-Regular" size:16];
    self.price.font=[UIFont fontWithName:@"MuseoSlab-500" size:28];
    self.location.font=[UIFont fontWithName:@"ProximaNovaCond-Regular" size:23];
    self.localabel.font=[UIFont fontWithName:@"ProximaNovaCond-Regular" size:23];
    self.avalabel.font=[UIFont fontWithName:@"ProximaNovaCond-Regular" size:23];
    self.avalabletime.font=[UIFont fontWithName:@"ProximaNovaCond-Regular" size:23];
    PFFile *imageFile = [self.detailItem objectForKey:@"bookcover"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            self.bookcover.image = image;
        }
    }];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"mark"]) {
        
        NSLog(@"%@",self.detailItem);
        
        MarkedBook = [PFObject objectWithClassName:@"MarkedBook"];
        
        MarkedBook[@"title"] = [self.detailItem objectForKey:@"title"];
        MarkedBook[@"provider"] = [self.detailItem objectForKey:@"provider"];
        MarkedBook[@"price"] = [self.detailItem objectForKey:@"price"];
        MarkedBook[@"macaddress"] = self.Macaddress;
        MarkedBook[@"ISBN"] = [self.detailItem objectForKey:@"ISBN"];
        MarkedBook[@"location"] = [self.detailItem objectForKey:@"location"];
        MarkedBook[@"avalabletime"] = [self.detailItem objectForKey:@"avalabletime"];
        MarkedBook[@"bookcover"] = [self.detailItem objectForKey:@"bookcover"];
        MarkedBook[@"author"]=[self.detailItem objectForKey:@"author"];
        MarkedBook[@"subtitle"]=[self.detailItem objectForKey:@"subtitle"];
        MarkedBook[@"contact"] = [self.detailItem objectForKey:@"contact"];
        
        [MarkedBook saveInBackground];
        
        
    }
    [NSThread sleepForTimeInterval:.5];
}

- (id)initWithNibNameforIphone4:(NSString *)nibNameOrNil4 NibNameforIphone5:(NSString *)nibNameOrNil5 NibNameforIpad:(NSString *)nibNameOrNilpad bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super init])
    {
        self = [self initWithNibName:[self CheckDeviceIphone4:nibNameOrNil4 Iphone5:nibNameOrNil5 Ipad:nibNameOrNilpad] bundle:nibBundleOrNil];
    }
    return self;
    
}

-(NSString *)CheckDeviceIphone4:(NSString *)iphone4 Iphone5:(NSString *)iphone5 Ipad:(NSString *)ipad {
    
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? ipad :([[UIScreen mainScreen] bounds].size.height == 568) ?  iphone5 :iphone4;
}

@end
