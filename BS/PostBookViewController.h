//
//  PostBookViewController.h
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/parse.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface PostBookViewController : UIViewController<UITextFieldDelegate,UITextInputDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIWebViewDelegate>{
    IBOutlet UIScrollView *scroller;

}
@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet UITextField *ISBNfield;
@property (weak, nonatomic) IBOutlet UITextView *InfoTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *LocationField;
@property (weak, nonatomic) IBOutlet UITextField *PriceField;
@property (weak, nonatomic) IBOutlet UITextField *AvalableTimeField;
@property (weak, nonatomic) IBOutlet UITextView *providerField;
@property (strong, nonatomic) IBOutlet UIImageView *BookCover;
@property (strong,nonatomic) NSString* CampusLocatioin;
@property (strong,nonatomic) NSString* ISBN;
@property (strong,nonatomic) NSString* objectid;
@property (strong,nonatomic) NSString* booktitle;
@property (strong,nonatomic) NSString* subtitle;
@property (strong,nonatomic) NSString* author;
- (IBAction)transform:(id)sender;
- (IBAction)Capture:(id)sender;
@property (strong,nonatomic) NSString* Macaddress;
@property (weak, nonatomic) IBOutlet UITextField *Providerfield;
@property (weak, nonatomic) IBOutlet UITextField *AuthorField;
-(void)dismissKeyboard;
@end
