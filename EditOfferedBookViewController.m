//
//  EditOfferedBookViewController.m
//  BS
//
//  Created by Jiaqi Chen on 4/3/14.
//  Copyright (c) 2014 Jiaqi Chen. All rights reserved.
//

#import "EditOfferedBookViewController.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
@interface EditOfferedBookViewController ()

@end

@implementation EditOfferedBookViewController
{
    PFObject *MarkedBook;
    PFObject *OfferedBook;
    PFQuery *query;
    PFFile *imageFile;
}


@synthesize Macaddress,Mark,Offer,CampusLocatioin,objectId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.navigationController.toolbarHidden = NO;
    // Do any additional setup after loading the view.
    //self.view.backgroundColor=colorchange(127,191,212,0.9);
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barTintColor = colorchange(127,191,212,0.9);
    self.navigationController.toolbar.barTintColor=colorchange(127,191,212,0.9);    UILabel *label=[[UILabel alloc]init];
    if(Mark==YES)
        label.text=@"BookInfo";
    if (Offer==YES)     label.text=@"EditBookInfo";
    label.text=@"EditBookInfo";
    label.textColor=colorchange(255, 255, 255, 1);
    label.backgroundColor=[UIColor clearColor];
    label.font = [UIFont fontWithName:@"Avenir-Light" size:32.0];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    self.
    self.ISBNField.text = [self.detailItem objectForKey:@"title"];
    self.LocationField.text = [self.detailItem objectForKey:@"location"];
    self.PostTextView.text = [self.detailItem objectForKey:@"contact"];
    self.PriceField.text = [self.detailItem objectForKey:@"price"];
    self.AvalableTimeField.text = [self.detailItem objectForKey:@"avalabletime"];
    PFFile *imageFile;
    imageFile = [self.detailItem objectForKey:@"bookcover"];
    //image = [UIImage imagewith];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            // image can now be set on a UIImageView
            self.BookCover.image = image;
        }
    }];
    
    [self configureView];
    
    
    if(Mark == YES){
        [self.ISBNField setEnabled:NO];
        [self.LocationField setEnabled:NO];
        [self.PostTextView setEditable:NO];
        [self.PriceField setEnabled:NO];
        [self.AvalableTimeField setEnabled:NO];
        [self.CameraRoll setEnabled:NO];
        [self.SaveEdit setEnabled:NO];
        [self.showlocation setEnabled:NO];
    }
}
-(void)dismisskeyboard{
        [self.ISBNField resignFirstResponder];
        [self.PriceField resignFirstResponder];
        [self.PostTextView resignFirstResponder];
        [self.LocationField resignFirstResponder];
        [self.AvalableTimeField resignFirstResponder];
        [self.providerField resignFirstResponder];
        [self.showlocation resignFirstResponder];
        
  
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    NSLog(@"Return my key was hit! which =%@",textField.text);
    return YES;
}

-(void) animateTextView:(UITextView *)textView up:(BOOL)up{
    const int movedis=210;
    const float movedur=0.3f;
    int movement=(up ?-movedis:movedis);
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movedur];
    self.view.frame=CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"a");
    [self animateTextView:textView up:YES];
    //[textView resignFirstResponder];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"b");
    [self animateTextView:textView up:NO];
    [textView resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"delete"]) {
        if (Mark == YES) {
            NSLog(@"%@",objectId);
            //MarkedBook = [PFObject objectWithClassName:@"MarkedBook"];
            PFObject *object = [PFObject objectWithoutDataWithClassName:@"MarkedBook"
                                                               objectId:objectId];
            [object deleteEventually];
            [MarkedBook saveInBackground];
        }
        if (Offer == YES) {
            //OfferedBook = [PFObject objectWithClassName:@"PublicBookPost"];
            PFObject *object = [PFObject objectWithoutDataWithClassName:@"PublicBookPost"
                                                               objectId:objectId];
            [object deleteEventually];
            [MarkedBook saveInBackground];
        }

    }
    if ([[segue identifier] isEqualToString:@"doneEdit"]) {
        
        UIImage *image;
        image = _BookCover.image;
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
        
        imageFile = [PFFile fileWithName:@"bookcover.png" data:imageData];
        
        query = [PFQuery queryWithClassName:@"PublicBookPost"];
        
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:objectId block:^(PFObject *PublicBookPost, NSError *error) {
            
            // Now let's update it with some new data. In this case, only cheatMode and score
            // will get sent to the cloud. playerName hasn't changed.
            PublicBookPost[@"ISBN"] = self.ISBNField.text;
            PublicBookPost[@"location"] = self.LocationField.text;
            PublicBookPost[@"price"] = self.PriceField.text;
            PublicBookPost[@"avalabletime"] = self.AvalableTimeField.text;
            PublicBookPost[@"contact"] = self.PostTextView.text;
            PublicBookPost[@"bookcover"] = imageFile;
            
            [PublicBookPost saveInBackground];
            
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _BookCover.image = image;
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

- (IBAction)CameraRoll:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = NO;
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
