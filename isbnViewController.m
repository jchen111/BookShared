//
//  isbnViewController.m
//  BS
//
//  Created by zhaoyixuan on 4/29/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import "isbnViewController.h"
#import "PostBookViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
@interface isbnViewController ()

@end

@implementation isbnViewController
{
    NSArray *returnvaluearray;
    PFObject *PublicBook;
}
@synthesize ISBN,objectid,booktitle,subtitle,author,webview,button;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 650)];
    
    
    self.view.backgroundColor=colorchange(242, 242, 242, 1.0);
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barTintColor=colorchange(127, 191, 212, 0.9);
    self.navigationController.toolbarHidden=YES;
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor=colorchange(127,191,212,0.9);
    [webview loadRequest:[NSURLRequest requestWithURL:
                               [NSURL fileURLWithPath:
                                [[NSBundle mainBundle] pathForResource:@"a" ofType:@"html"]]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self.titletextField setEnabled:NO];
    [self.authortextField setEnabled:NO];
}
-(void)dismissKeyboard{
    [self.isbntextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"gotopost"]) {
        NSLog(@"other: %@,%@,%@,%@",booktitle,subtitle,author,ISBN);
       // [[segue destinationViewController]setObjectId:objectid];
        [[segue destinationViewController] setISBN:ISBN];
        [[segue destinationViewController] setBooktitle:booktitle];
        [[segue destinationViewController]setSubtitle:subtitle];
        [[segue destinationViewController]setAuthor:author];
        NSLog(@"other: %@,%@,%@,%@",booktitle,subtitle,author,ISBN);
    }
}



- (IBAction)isbntransgorm:(id)sender {
    NSString *returnvalue;
    ISBN=self.isbntextField.text;
    NSString *js = [NSString stringWithFormat:@"getBook('%@');",ISBN];
    NSLog(@"%@",
          self.isbntextField.text);
    returnvalue=[webview stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"return is :%@",returnvalue);
    
    js=[NSString stringWithFormat:@"showOnBrowser()"];
    [webview stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"return is :%@",returnvalue);
    returnvaluearray=[returnvalue componentsSeparatedByString:@"/"];
    NSLog(@"value is:%@",returnvaluearray);
    
//    [NSThread sleepForTimeInterval:.5];
//    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
   
}

- (IBAction)textshow:(id)sender {

    self.titletextField.text=[returnvaluearray objectAtIndex:0];
    //self.titletextField.font=[UIFont fontWithName:@"AlternateGotNo3D" size:30];
    self.subtitletextview.text=[returnvaluearray objectAtIndex:1];
    self.subtitletextview.font=[UIFont fontWithName:@"Helvetica Neue" size:18];
   // self.subtitletextview.font=[UIFont fontWithName:@"ProximaNovaCond-RegularIt" size:24];
    self.authortextField.text=[returnvaluearray objectAtIndex:2];
    booktitle=self.titletextField.text;
    subtitle=self.subtitletextview.text;
    author=self.authortextField.text;
    NSLog(@"other: %@,%@,%@",booktitle,subtitle,author);
}
@end
