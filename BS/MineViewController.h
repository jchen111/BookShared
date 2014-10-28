//
//  MineViewController.h
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>

@interface MineViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SideBarMenuButton;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentcontrol;
@property (strong,nonatomic) NSMutableArray *Marked;
@property (strong,nonatomic) NSMutableArray *Offered;
@property (strong) NSString *Macaddress;

- (IBAction)segmentedControlChanged:(id)sender;
@end
