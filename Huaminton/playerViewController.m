//
//  playerViewController.m
//  Huaminton
//
//  Created by MengHua on 4/25/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "playerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface playerViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIPickerView *colorPicker;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (nonatomic) UIImagePickerController *imagePicker;
@end

@implementation playerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.colorPicker.delegate = self;
    self.colorPicker.dataSource = self;
    
    [self.nameText setText:self.player.name];
    [self.colorPicker selectRow:0 inComponent:0 animated:FALSE];
    [self.photoImageView setImage:[UIImage imageWithContentsOfFile:self.player.photoImage]];
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    
}

- (IBAction)doneAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.colorAvailable count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    switch ([[self.colorArray objectAtIndex:[self.colorAvailable[row] intValue]] intValue]) {
        case HUAMINTON_COLOR_RED:
            [rowView setBackgroundColor:[UIColor redColor]];
            break;
        case HUAMINTON_COLOR_YELLOW:
            [rowView setBackgroundColor:[UIColor yellowColor]];
            break;
        case HUAMINTON_COLOR_GREEN:
            [rowView setBackgroundColor:[UIColor greenColor]];
            break;
        case HUAMINTON_COLOR_BLUE:
            [rowView setBackgroundColor:[UIColor blueColor]];
            break;
        case HUAMINTON_COLOR_PURPLE:
            [rowView setBackgroundColor:[UIColor purpleColor]];
            break;
        case HUAMINTON_COLOR_BROWN:
            [rowView setBackgroundColor:[UIColor brownColor]];
            break;
        case HUAMINTON_COLOR_MAGENTA:
            [rowView setBackgroundColor:[UIColor magentaColor]];
            break;
        case HUAMINTON_COLOR_CYAN:
            [rowView setBackgroundColor:[UIColor cyanColor]];
            break;
        default:
            break;
    }
    return rowView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.player.color = [self.colorAvailable[row] intValue];
    [self tapView:nil];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 200;
}

- (IBAction)tapView:(UITapGestureRecognizer *)sender {
    if ([[self.nameText text] isEqualToString:@""]) {
        [self.nameText setText:self.player.name];
    } else {
        self.player.name = [self.nameText text];
    }
    [self.nameText resignFirstResponder];
}

- (IBAction)tapImage:(UITapGestureRecognizer *)sender {
//    NSLog(@"%f,,,,%f,,,,", self.photoImageView.frame.size.height,self.photoImageView.frame.size.width);
    
    [self tapView:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *mediaTypers = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([mediaTypers containsObject:(NSString *)kUTTypeImage]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage,nil];
            self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        UIGraphicsBeginImageContext(CGSizeMake(PHOTOSIZE, PHOTOSIZE));
        [image drawInRect:CGRectMake(0, 0, PHOTOSIZE, PHOTOSIZE)];
        UIImage *storageImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSFileManager *filem = [NSFileManager defaultManager];
        NSLog(@"Image file is %@.",self.player.photoImage);
        [filem createFileAtPath:self.player.photoImage contents:UIImageJPEGRepresentation(storageImage, 1.f) attributes:nil];
        
        [self.photoImageView setImage:[UIImage imageWithContentsOfFile:self.player.photoImage]];
        
    }
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(BOOL)shouldAutorotate {
    return FALSE;
}

@end
