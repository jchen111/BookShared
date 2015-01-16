

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#import "PostBookViewController.h"
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface PostBookViewController ()

@end

@implementation PostBookViewController
{
    PFObject *PublicBook;
    PFFile *imageFile;
    NSString *like_UDID;
    //UIWebView *webView;
}
@synthesize CampusLocatioin,Macaddress,ISBN,objectid,booktitle,subtitle,author;

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
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 650)];
    self.view.backgroundColor=colorchange(242, 242, 242, 1.0);
    self.navigationController.navigationBar.translucent=YES;
    self.navigationController.navigationBar.barTintColor = colorchange(127,191,212,0.9);
    self.navigationController.toolbar.barTintColor=colorchange(127,191,212,0.9);
    UILabel *label=[[UILabel alloc]init];
    label.text=@"Post Book";
    label.textColor=colorchange(255, 255, 255, 1);
    label.font = [UIFont fontWithName:@"Avenir-Light" size:32.0];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    self.navigationController.toolbarHidden = NO;
    
    
    self.navigationController.navigationBarHidden=NO;
    self.LocationField.text = CampusLocatioin;
    self.ISBNfield.text=ISBN;
    self.ISBNfield.enabled = FALSE;
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor=colorchange(139, 196, 215, 1.0);
    
    like_UDID=[NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    Macaddress = [like_UDID substringFromIndex:33];
    NSLog(@"%@",booktitle);
    NSLog(@"%@",subtitle);
    NSLog(@"%@",author);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dismissKeyboard{
    [self.titleField resignFirstResponder];
    [self.ISBNfield resignFirstResponder];
    [self.PriceField resignFirstResponder];
    [self.LocationField resignFirstResponder];
    [self.AvalableTimeField resignFirstResponder];
    [self.providerField resignFirstResponder];

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIImage *image;
    image = _BookCover.image;
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    
    imageFile = [PFFile fileWithName:@"bookcover.png" data:imageData];
    
    
    if ([[segue identifier] isEqualToString:@"save"]) {

        PublicBook = [PFObject objectWithClassName:@"PublicBookPost"];
        
        PublicBook[@"title"] = booktitle;
        
        PublicBook[@"location"] = self.LocationField.text;
        
        PublicBook[@"price"] = self.PriceField.text;
        
        PublicBook[@"ISBN"] = ISBN;
        
        PublicBook[@"provider"] = self.providerField.text;
        PublicBook[@"author"] = author;
        
        PublicBook[@"avalabletime"] = self.AvalableTimeField.text;
        
        PublicBook[@"contact"] = self.InfoTextView.text;
        PublicBook[@"bookcover"] = imageFile;
        PublicBook[@"macaddress"] = Macaddress;
        PublicBook[@"subtitle"]=subtitle;
        
        [PublicBook saveInBackground];
        
    }
    
    if ([[segue identifier] isEqualToString:@"gotolocationsearch"]) {
        
        [[segue destinationViewController] setMacaddress:Macaddress];
        [[segue destinationViewController] setISBN:self.ISBNfield.text];
        [[segue destinationViewController] setTitle:booktitle];
        [[segue destinationViewController] setSubtitle:subtitle];
        [[segue destinationViewController] setAuthor:author];
    }
    
}

#pragma mark invoke camera and choose photo here:
- (IBAction)CameraRoll:(id)sender{
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

- (IBAction)TakePicture:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString*) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
        _newMedia = YES;
        
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

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

- (IBAction)transform:(id)sender {
    [self performSegueWithIdentifier:@"gotoisbn" sender:self];
}

- (IBAction)Capture:(id)sender {
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    [cameraUI setDelegate:self];
    
    [cameraUI setAllowsEditing:YES];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController: cameraUI animated: YES completion:nil];
}
@end
