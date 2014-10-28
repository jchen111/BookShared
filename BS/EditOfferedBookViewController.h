//
//  EditOfferedBookViewController.h
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface EditOfferedBookViewController : UIViewController<UITextFieldDelegate,UITextInputDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UIScrollView *scroller;
}
@property (strong, nonatomic) IBOutlet UITextField *titletext;
@property (strong, nonatomic) IBOutlet UITextView *subtitletext;
@property (strong, nonatomic) IBOutlet UILabel *authorlabel;
@property (strong, nonatomic) IBOutlet UITextView *authortext;
@property (strong, nonatomic) IBOutlet UILabel *isbnlabel;

@property BOOL newMedia;
@property (strong, nonatomic) id detailItem;
@property NSString *objectId;
@property BOOL Mark;
@property BOOL Offer;
@property (strong, nonatomic) IBOutlet UILabel *locationlabel;

@property (strong, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet UITextView *PostTextView;
@property (weak, nonatomic) IBOutlet UITextField *ISBNField;
@property (weak, nonatomic) IBOutlet UITextField *LocationField;
@property (weak, nonatomic) IBOutlet UITextField *PriceField;
@property (weak, nonatomic) IBOutlet UITextField *AvalableTimeField;

@property (weak, nonatomic) IBOutlet UIButton *CameraRoll;

@property (strong, nonatomic) IBOutlet UIImageView *BookCover;
@property (strong,nonatomic) NSString* CampusLocatioin;
@property (strong,nonatomic) NSString* Macaddress;

@property (strong, nonatomic) IBOutlet UILabel *avalabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *SaveEdit;

@end
