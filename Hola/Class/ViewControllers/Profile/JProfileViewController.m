//
//  JProfileViewController.m
//  Hola
//
//  Created by Jin Wang on 30/3/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "JProfileViewController.h"
#import "SBJSON.h"
#import "SBJsonWriter.h"

#define OTHER_MEDIA_TAG_START 500
#define PHOTO_TYPE_MAIN   1
#define PHOTO_TYPE_ADDITIONAL 2
@interface JProfileViewController ()

@end

@implementation JProfileViewController

@synthesize mPageType;
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
+ ( JProfileViewController* ) sharedController
{
    __strong static JProfileViewController* sharedController = nil ;
    static dispatch_once_t onceToken ;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ JProfileViewController alloc ] initWithNibName : @"JProfileViewController" bundle : nil ] ;
    } ) ;
    return sharedController ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mPageType = @"introduction";

    [mImgProfilePhotoEdit.layer setCornerRadius:mImgProfilePhotoEdit.frame.size.height / 2];
    [mImgProfilePhotoEdit.layer setMasksToBounds:YES];
    [mImgProfilePhotoEdit.layer setBorderWidth:0];
    
    [mBtnProfileEdit.layer setCornerRadius:3.0f];
    [mBtnProfileEdit.layer setMasksToBounds:YES];
    [mScrollProfileEdit setHidden:NO];
    
    [mBtnProfileEditDone.layer setCornerRadius:3.0f];
    [mBtnProfileEditDone.layer setMasksToBounds:YES];
  //  [mBtnProfileEditDone setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1]];
    [mBtnProfileEditDone setBackgroundColor:[UIColor colorWithRed:251/255.0f green:107/255.0f blue:97/255.0f alpha:1]];
  
    
    UITapGestureRecognizer* recognizer;
    recognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBackground:)];
    recognizer.numberOfTouchesRequired=1;
    recognizer.delegate=self;
    [self.view addGestureRecognizer:recognizer];

    [mBtnShowSideLeftView setHidden:YES];
    [mBtnShowSideRightView setHidden:YES];
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-16];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];

    [datePicker setMaximumDate:maxDate];
    [datePicker setMinimumDate:minDate];
    
    [mTxtEditBirthday setInputView:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelDateSelection)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelBtn, spacer, doneBtn, nil]];
    [mTxtEditBirthday setInputAccessoryView:toolBar];
    
    
    [self initMedia];
}

-(void)CancelDateSelection {
    [mTxtEditBirthday resignFirstResponder];
}

-(void)ShowSelectedDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    mTxtEditBirthday.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:datePicker.date]];
    [mTxtEditBirthday resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{

    if([mPageType isEqualToString:@"setting"])
    {
        [mBtnShowSideRightView setHidden:NO];
        [mBtnShowSideLeftView setHidden:NO];
        [mBtnProceed setHidden:YES];
    }
    else
    {
        [mBtnShowSideRightView setHidden:YES];
        [mBtnShowSideLeftView setHidden:YES];
        [mBtnProceed setHidden:NO];
        
    }
    if(![Engine isBackAction])
    {
        [self initProfileEditView];
    }
    else
        [Engine setIsBackAction:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    if([[Engine gPersonInfo].mArrPic count] > 4)
    {
        [mBtnAddMorePhoto setHidden:YES];
    }

}
-(void)initProfileEditView
{
    JUserInfo *pUser = [Engine gPersonInfo];
    mTxtEditEmail.text = pUser.mEmail;
    mTxtEditBirthday.text = [NSString stringWithFormat:@"%@", pUser.mBirthday];
    mTxtEditCity.text = pUser.mLocation;
    mSegEditGender.selectedSegmentIndex = [pUser.mGender integerValue];
    mTxtAbout.text = pUser.mDescription;
    [mImgProfilePhotoEdit setImageWithURL:[NSURL URLWithString:pUser.mPhotoUrl] placeholderImage:[UIImage  imageNamed:@"user_placeholder.png"]];
    [[mViewEditUserOtherPhotoContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    mIndicatorProfileMainPhoto.hidesWhenStopped = YES;
    [self initSubPhotos];
}
-(void)onTapBackground:(id)sender
{
    if([mTxtEditBirthday isFirstResponder])
        return;
    [mTxtAbout endEditing:YES];
    [mTxtEditEmail endEditing:YES];
    [mTxtEditCity endEditing:YES];
    [mTxtEditBirthday endEditing:YES];

    //    [mTxtBusiness endEditing:YES];
}
-(void)initMedia
{
//    UIViewContentModeScaleAspectFill
    [mBgGrayView setFrame:CGRectMake(0, 0,320,SCREEN_HEIGHT)];
    [mBgGrayView setHidden:YES];
    [mDeletePhotoConfirmView setFrame:CGRectMake(20, (SCREEN_HEIGHT-mDeletePhotoConfirmView.frame.size.height)/2.0,280, mDeletePhotoConfirmView.frame.size.height)];
    [mDeletePhotoConfirmView setHidden:YES];
        [mScrollProfileEdit setFrame:CGRectMake(0, SCREEN_HEIGHT - mScrollProfileEdit.frame.size.height, mScrollProfileEdit.frame.size.width, mScrollProfileEdit.frame.size.height)];
    
    [self.view addSubview:mScrollProfileEdit];
    [self.view addSubview:mBgGrayView];
    [self.view addSubview:mDeletePhotoConfirmView];
//    [self.view insertSubview:mScrollProfileEdit belowSubview:mViewProfileContainer];


    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}
-(IBAction)onTouchChangePage:(id)sender
{
    if(sender==mPageControl)
    {
        [mScrollPhotoView setContentOffset:CGPointMake(mScrollPhotoView.frame.size.width*mPageControl.currentPage, 0) animated:YES];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int mNewPage=scrollView.contentOffset.x/scrollView.frame.size.width;
    if(scrollView==mScrollPhotoView)
    {
        if(mPageControl.currentPage!=mNewPage)
        {
            mPageControl.currentPage=scrollView.contentOffset.x/scrollView.frame.size.width;
        }
    }
    
    NSLog(@"scrollViewDidEndDecelerating: %f",scrollView.contentOffset.x);
}

-(IBAction)onTapUserMainPhoto :(id)sender
{
    
//    [self onTapBackground:nil];
    photoType = PHOTO_TYPE_MAIN;
    UIActionSheet* actionSheet = [ [ UIActionSheet alloc ] initWithTitle : @"Add Photo"
                                                                delegate : self
                                                       cancelButtonTitle : @"Cancel"
                                                  destructiveButtonTitle : @"Camera"
                                                       otherButtonTitles : @"From Photo Library", nil ] ;
    [ actionSheet showInView : self.view ] ;
}

#pragma mark actionsheet for main and profile photos
- (void)actionSheet: (UIActionSheet *) _actionSheet clickedButtonAtIndex : (NSInteger) _buttonIndex
{
    if([_actionSheet.title isEqualToString: @"Add Photo"] || [_actionSheet.title isEqualToString: @"Add Video"] )
    {
        UIImagePickerController* pickerController = nil;
        [Engine setIsBackAction:YES];
        switch(_buttonIndex)
        {
            case 0: // Camera ;
                if([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO)
                {
                    return ;
                }
                
                pickerController = [[UIImagePickerController alloc] init];
                pickerController.delegate  = self;
                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                //                pickerController
                if([_actionSheet.title isEqualToString: @"Add Photo"])
                    pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                else
                    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
                
                pickerController.allowsEditing = YES;
                
                [self presentViewController: pickerController animated: YES completion: nil];
                [Engine setIsBackAction:YES];
                break ;
            case 1: // Photo ;
                pickerController = [[UIImagePickerController alloc] init];
                pickerController.delegate = self;
                pickerController.allowsEditing = YES;
                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                
                [self presentViewController: pickerController animated: YES completion: nil];
                [Engine setIsBackAction:YES];
                break ;
            default :
                break ;
        }
        
    }
}
- (void)imagePickerController: (UIImagePickerController *) _picker didFinishPickingMediaWithInfo: (NSDictionary *) _info
{
    
    NSURL *mediaUrl = (NSURL *)[_info valueForKey: UIImagePickerControllerMediaURL];
    NSString *mediaType = [_info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:@"public.image"])
    {
        if(mediaUrl == nil)
        {
            
            if(photoType == PHOTO_TYPE_MAIN)
            {
                mImgProfilePhotoEdit.image = [_info valueForKey: UIImagePickerControllerEditedImage];
                
                [_picker dismissViewControllerAnimated : YES completion : ^{
                }];
                [self uploadProfileMainPhoto];
            }
            else if(photoType == PHOTO_TYPE_ADDITIONAL)
            {
                [self uploadProfileSubPhoto : [_info valueForKey: UIImagePickerControllerEditedImage]];
                [_picker dismissViewControllerAnimated : YES completion : ^{
                }];
            }
            
            
        }
    }
}
-(void)uploadProfileMainPhoto
{
    [mIndicatorProfileMainPhoto startAnimating];
    mBtnAddMainPhoto.enabled=NO;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [NSString stringWithFormat:@"%d",1],@"image_attached",  nil];
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *jsonArgs = [jsonWriter stringWithObject: args];
            
            NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
            [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
            [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
            [parameters setObject:jsonArgs forKey:@"updatelist"];
            [parameters setObject:@"users" forKey:@"type"];
            [parameters setObject:@"update_main_photo" forKey:@"cmd"];
            
            
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                NSData *imageData=UIImageJPEGRepresentation(mImgProfilePhotoEdit.image, 0.8);
                [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
                NSString *res = [dict objectForKey: @"success"];
                //  NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                 NSLog(@"Error Data %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                
                if ([res isEqualToString: @"1"])
                {
                    NSDictionary *data = [dict objectForKey: @"data"];
                    NSString *error1 = [data objectForKey: @"error"];
                    
                    if([error1 isEqualToString:@"1"])
                    {
                        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                        [mIndicatorProfileMainPhoto stopAnimating];
                    }
                    else
                    {
                        [SVProgressHUD dismiss];
                        [[Engine gPersonInfo] setDataWithDictionary:[data objectForKey:@"user"]];
                        [[NSNotificationCenter defaultCenter] postNotificationName: PROFILE_PICTURE_CHANGED object: nil];

                    }
                    [mIndicatorProfileMainPhoto stopAnimating];
                    mBtnAddMainPhoto.enabled=YES;
                }
                else
                {
                    mBtnAddMainPhoto.enabled=YES;
                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                mBtnAddMainPhoto.enabled=YES;
                [mIndicatorProfileMainPhoto stopAnimating];
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            }];
            
        });
        
        
    });

}

-(void)uploadProfileSubPhoto :(UIImage *)img
{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [mBtnAddMorePhoto setEnabled:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^ {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *args = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [NSString stringWithFormat:@"%d",1],@"image_attached",  nil];
            SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
            NSString *jsonArgs = [jsonWriter stringWithObject: args];
            
            NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
            [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
            [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
            [parameters setObject:jsonArgs forKey:@"updatelist"];
            [parameters setObject:@"users" forKey:@"type"];
            [parameters setObject:@"update_profile_photo" forKey:@"cmd"];
            
            
            AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                NSData *imageData=UIImageJPEGRepresentation(img, 0.8);
                [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
                
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
                NSString *res = [dict objectForKey: @"success"];
                //  NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                 NSLog(@"Error Data %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                
                if ([res isEqualToString: @"1"])
                {
                    NSDictionary *data = [dict objectForKey: @"data"];
                    NSString *error1 = [data objectForKey: @"error"];
                    
                    if([error1 isEqualToString:@"1"])
                    {
                        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
  
                    }
                    else
                    {
                        [[Engine gPersonInfo] setDataWithDictionary:[data objectForKey:@"user"]];
                        if([[Engine gPersonInfo].mArrPic count] > 4)
                        {
                            [mBtnAddMorePhoto setHidden:YES];
                        }
                        [self initSubPhotos];
                        mBtnAddMorePhoto.enabled=YES;

                    }
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                }
                else
                {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    mBtnAddMorePhoto.enabled=YES;
                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                mBtnAddMorePhoto.enabled=YES;
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];

            }];
            
        });
        
        
    });
    
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [mBtnAddMorePhoto setEnabled:YES];
}
#pragma mark edit view
-(IBAction)onTouchBtnProfileEdit:(id)sender
{
    mBtnProfileEdit.enabled=false;
//    [mBtnEditDone setHidden:NO];
    //mBtnAddMainPhoto.userInteractionEnabled = NO;
    [self showEditView];
}
-(IBAction)onTouchBtnProfileEditDone:(id)sender
{
    mBtnProfileEdit.enabled=YES;
    //mBtnAddMainPhoto.userInteractionEnabled = YES;
    [self hideEditView];
}
-(void)showEditView
{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        mViewProfileContainer.transform = CGAffineTransformMakeTranslation(0,mViewProfileContainer.frame.size.height);
    } completion:^(BOOL finished){
        [mBtnProfileEditDone setHidden:NO];
        [mBtnProfileEdit setHidden:YES];
        [mScrollProfileEdit setHidden:NO];
        
        mScrollProfileEdit.transform = CGAffineTransformMakeTranslation(0,mScrollProfileEdit.frame.size.height);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            mScrollProfileEdit.transform = CGAffineTransformMakeTranslation(0,SCREEN_HEIGHT - mScrollProfileEdit.frame.size.height);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                //mViewEditContainer.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
            }];
        }];
    }];
}
-(void)hideEditView
{
    //    mEditView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        mScrollProfileEdit.transform =  CGAffineTransformMakeTranslation(0,mScrollProfileEdit.frame.size.height);
    } completion:^(BOOL finished){
        [mBtnProfileEditDone setHidden:YES];
        [mBtnProfileEdit setHidden:NO];
        
        mScrollProfileEdit.hidden = YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            mViewProfileContainer.transform = CGAffineTransformMakeTranslation(0,0);
        } completion:^(BOOL finished){
            // do something once the animation finishes, put it here
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                mViewProfileContainer.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                // do something once the animation finishes, put it here
            }];
        }];
        
    }];
}
- (void)initSubPhotos
{
    //NSMutableArray* photos=[Engine gPersonInfo].mArrPic;
    NSMutableArray* photos=[Engine gPersonInfo].mArrPic;
    [mLblOtherPhotoEditTitle setText:[NSString stringWithFormat:@"Photos • %d", (int)[photos count]+1]];
    [[mViewEditUserOtherPhotoContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [mViewEditUserOtherPhotoContainer setFrame:CGRectMake(0,0,30+60*photos.count, 60)];
    [mScrollEditUserOtherPhotos setContentSize:CGSizeMake(30+photos.count*60, 60)];
    JPictureInfo* photo;
    int i;
    for(i=0;i<[photos count];i++)
    {
        photo=[photos objectAtIndex:i];
        UIButton *thumbItem = [[UIButton alloc] initWithFrame:CGRectMake(60*i+15, 5, 48, 48)];
        thumbItem.layer.masksToBounds=YES;
        
        UIImageView *pImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
        [pImage setContentMode:UIViewContentModeScaleAspectFill];
        [pImage setImageWithURL:[NSURL URLWithString:[photo mFileUrl]] placeholderImage:[UIImage imageNamed:@"user_placeholder.png"]]; // need to be changed as thumb
        [thumbItem addSubview:pImage];
        [thumbItem setTag: OTHER_MEDIA_TAG_START+i];
        [thumbItem.layer setCornerRadius:thumbItem.frame.size.width / 2];
        
        //[thumbItem addTarget:self action:@selector(onTouchBtnPhoto:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *pBtnRemoveThumb = [[UIButton alloc]initWithFrame:CGRectMake(60*i+10 + 38, 5, 15, 15)];
        [pBtnRemoveThumb.layer setCornerRadius:10];
        [pBtnRemoveThumb.layer setMasksToBounds:YES];
        [pBtnRemoveThumb addTarget:self action:@selector(onTouchBtnRemovePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [pBtnRemoveThumb setBackgroundImage:[UIImage imageNamed:@"btnIconPhotoDelete.png"] forState:UIControlStateNormal];
        pBtnRemoveThumb.tag = OTHER_MEDIA_TAG_START + i;
        [pBtnRemoveThumb setBackgroundColor:[UIColor colorWithRed:251/255.0 green:107/255.0 blue:97/255.0 alpha:1]];
        
        [mViewEditUserOtherPhotoContainer addSubview: thumbItem];
        [mViewEditUserOtherPhotoContainer addSubview:pBtnRemoveThumb];
    }

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

#pragma mark small profile photo setting
-(void)onTouchBtnSmallPhoto:(id)sender
{

}
-(IBAction)onTouchBtnAddSubPhoto:(id)sender
{
    photoType = PHOTO_TYPE_ADDITIONAL;
    UIActionSheet* mActionSheet = [ [ UIActionSheet alloc ] initWithTitle : @"Add Photo"
                                                                delegate : self
                                                       cancelButtonTitle : @"Cancel"
                                                  destructiveButtonTitle : @"Camera"
                                                       otherButtonTitles : @"From Photo Library", nil ] ;
    [mActionSheet showInView:self.view];

}

-(void)onTouchBtnRemovePhoto:(id)sender
{
    [mBgGrayView setHidden:NO];
    [mDeletePhotoConfirmView setHidden:NO];
    
    UIButton* btn=(UIButton*)sender;
    deletePic=(int)btn.tag-OTHER_MEDIA_TAG_START;//[Engine gPersonInfo].mArrPic objectAtIndex:
    mDeletePhotoConfirmView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        mDeletePhotoConfirmView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
}

-(IBAction)onTouchBtnDeleteConfirmCancel:(id)sender
{
    mDeletePhotoConfirmView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        mDeletePhotoConfirmView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [mBgGrayView setHidden:YES];
        mDeletePhotoConfirmView.hidden = YES;
    }];

}
-(IBAction)onTouchBtnDeleteConfirmOk:(id)sender
{
    JPictureInfo *photo = [[Engine gPersonInfo].mArrPic objectAtIndex:deletePic];
    
    
    mDeletePhotoConfirmView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        mDeletePhotoConfirmView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [mBgGrayView setHidden:YES];
        mDeletePhotoConfirmView.hidden = YES;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [mBtnAddMorePhoto setEnabled:NO];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^ {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
                [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
                [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
                [parameters setObject:photo.mPhotoId forKey:@"photo_id"];
                [parameters setObject:@"users" forKey:@"type"];
                [parameters setObject:@"delete_profile_photo" forKey:@"cmd"];
                
                
                AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
                    NSString *res = [dict objectForKey: @"success"];
                    //  NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    // NSLog(@"Error Data %@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                    [mBtnAddMorePhoto setEnabled:YES];
                    if ([res isEqualToString: @"1"])
                    {
                        NSDictionary *data = [dict objectForKey: @"data"];
                        NSString *error1 = [data objectForKey: @"error"];
                        
                        if([error1 isEqualToString:@"1"])
                        {
                            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                        }
                        else
                        {

                            [[Engine gPersonInfo] setDataWithDictionary:[data objectForKey:@"user"]];
                            [mBtnAddMorePhoto setHidden:NO];
                            //[self initView];
                            [self initProfileEditView];
                            [self  initSubPhotos];
                        }
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        
                    }
                    else
                    {
                        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [mBtnAddMorePhoto setEnabled:YES];
                    [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
                }];

                
            });
            
        });
        
    }];
}

#pragma mark keyboard notification
-(void) keyboardWillHide:(NSNotification *)note{
    if([mTxtEditBirthday isFirstResponder])
        return;
    NSDictionary *info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [mScrollProfileEdit setContentSize:CGSizeMake(mScrollProfileEdit.frame.size.width,mScrollProfileEdit.contentSize.height - kbSize.height)];
    [mScrollProfileEdit setContentOffset:CGPointMake(0, 0)];
    
}
-(void) keyboardWillShow:(NSNotification *)note{
    if([mTxtEditBirthday isFirstResponder])
        return;
    
    NSDictionary *info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [mScrollProfileEdit setContentSize:CGSizeMake(mScrollProfileEdit.frame.size.width,mScrollProfileEdit.contentSize.height + kbSize.height)];
    
    if([mTxtAbout isFirstResponder] )
        [mScrollProfileEdit setContentOffset:CGPointMake(0, mScrollProfileEdit.frame.size.height - kbSize.height)];
    if([mTxtEditCity isFirstResponder])
        [mScrollProfileEdit setContentOffset:CGPointMake(0, mScrollProfileEdit.frame.size.height - kbSize.height - 150)];
    
}





-(IBAction)onTouchBtnNext:(id)sender
{
    [self onTouchBtnSaveProfile:nil];
}


#pragma mark view from setting

-(IBAction)onTouchBtnSaveProfile:(id)sender
{
    
    NSString *pAge = @"";
    if(![mTxtEditBirthday.text isKindOfClass:[NSNull class]])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        if(![mTxtEditBirthday.text isEqualToString:@""])
        {
            NSDate *date = [dateFormatter dateFromString:mTxtEditBirthday.text];
            if(date)
                pAge = [NSString stringWithFormat:@"%ld", (long)[AppEngine ageFromBirthday:date]];
        }else {
            pAge = @"0";
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSInteger gender = mSegEditGender.selectedSegmentIndex;
    

    NSMutableDictionary *args = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0",@"image_attached",  nil];
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString *jsonArgs = [jsonWriter stringWithObject: args];
    
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[Engine gPersonInfo].mUserId forKey:@"userid"];
    [parameters setObject:[Engine gPersonInfo].mSessToken forKey:@"sesstoken"];
    [parameters setObject:@"users" forKey:@"type"];
    [parameters setObject:@"save_profile" forKey:@"cmd"];
    [parameters setObject:jsonArgs forKey:@"updatelist"];
    
    [parameters setObject:[Engine gPersonInfo].mFirstName forKey:@"firstname"];
    [parameters setObject:[Engine gPersonInfo].mLastName forKey:@"lastname"];
    [parameters setObject:mTxtEditCity.text forKey:@"city"];
    [parameters setObject:pAge forKey:@"age"];
    
    [parameters setObject:mTxtEditEmail.text forKey:@"email"];
    [parameters setObject:[NSString stringWithFormat:@"%d",(int)gender] forKey:@"gender"];
    [parameters setObject:mTxtEditBirthday.text forKey:@"birthday"];
    [parameters setObject:mTxtAbout.text forKey:@"description"];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:WEB_SITE_BASE_URL]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:WEB_SERVICE_RELATIVE_URL parameters:parameters constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *res = [dict objectForKey: @"success"];
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);

        if ([res isEqualToString: @"1"])
        {
            NSDictionary *data = [dict objectForKey: @"data"];
            NSString *error1 = [data objectForKey: @"error"];
            
            if([error1 isEqualToString:@"1"])
            {
                [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
            }
            else
            {
                [SVProgressHUD dismiss];
                [[Engine gPersonInfo] setDataWithDictionary:[data objectForKey:@"user"]];
                [self onTapBackground:nil];
                 [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_MAIN_VIEW object:nil];
             //   [self hideEditView];
              //  mBtnProfileEdit.enabled=YES;
             //   mBtnAddMainPhoto.userInteractionEnabled = YES;
            }
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        }
        else
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [SVProgressHUD showErrorWithStatus:MSG_SERVICE_UNAVAILABLE];

    }];

  

}
-(IBAction)onTouchBtnLeftMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_LEFTBTN_TOUCH object: nil];
}
-(IBAction)onTouchBtnRightMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName: HOME_RIGHTBTN_TOUCH object: nil];
}
@end
