//
//  DetailViewController.h
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverBookViewController.h"

@interface BookInfoViewController : UIViewController{
    IBOutlet UIScrollView *scroller;
}
@property (strong, nonatomic) IBOutlet UITextView *authoretxt;
@property (strong, nonatomic) IBOutlet UILabel *localabel;
@property (strong, nonatomic) IBOutlet UITextView *avalabel;

@property (strong, nonatomic) IBOutlet UILabel *isbntext;
@property (strong, nonatomic) IBOutlet UITextView *subtitletextview;
@property (strong, nonatomic) IBOutlet UILabel *isbnlabel;
@property (strong, nonatomic) id detailItem;
@property (strong) NSString *Macaddress;
@property (weak, nonatomic) IBOutlet UILabel *booktitle;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *avalabletime;
@property (weak, nonatomic) IBOutlet UIImageView *bookcover;
@property (weak, nonatomic) IBOutlet UITextView *contact;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (id)initWithNibNameforIphone4:(NSString *)nibNameOrNil4 NibNameforIphone5:(NSString *)nibNameOrNil5 NibNameforIpad:(NSString *)nibNameOrNilpad bundle:(NSBundle *)nibBundleOrNil;
@end
