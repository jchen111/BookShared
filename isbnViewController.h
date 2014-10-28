//
//  isbnViewController.h
//  BS
//
//  Created by zhaoyixuan on 4/29/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface isbnViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UIScrollView *scroller;
}
- (IBAction)isbntransgorm:(id)sender;
- (IBAction)textshow:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UITextField *isbntextField;
@property (strong, nonatomic) IBOutlet UITextField *titletextField;
@property (strong, nonatomic) IBOutlet UITextField *authortextField;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) IBOutlet UITextView *subtitletextview;
@property (strong,nonatomic) NSString* ISBN;
@property (strong,nonatomic) NSString* objectid;
@property (strong,nonatomic) NSString* booktitle;
@property (strong,nonatomic) NSString* subtitle;
@property (strong,nonatomic) NSString* author;
@property (strong,nonatomic) NSString* macaddress;


@end
