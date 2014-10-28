//
//  MasterViewController.h
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>

@interface DiscoverBookViewController:PFQueryTableViewController<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *SideBarMenuButton;
@property (strong) NSString *className;
@end
