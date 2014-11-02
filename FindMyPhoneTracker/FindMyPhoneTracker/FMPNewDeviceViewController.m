//
//  FMPNewDeviceViewController.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 31.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "SVProgressHUD.h"
#import "FMPNewDeviceViewController.h"
#import "FMPApiController.h"
#import "AppDelegate.h"
#import "FMPTestTrackerViewController.h"
#import "FMPDefaultsController.h"
#import "FMPHelpers.h"

@interface FMPNewDeviceViewController ()

@property (weak, nonatomic) IBOutlet UIView* scrollableView;
@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UITextField* deviceNameTextField;
@property (weak, nonatomic) IBOutlet UITextField* deviceDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField* deviceIDTextField;
@property (weak, nonatomic) IBOutlet UIButton* submitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomSpaceConstraint;

@end

@implementation FMPNewDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tapGesture];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.deviceIDTextField.text = [UIDevice currentDevice].identifierForVendor.UUIDString;
    self.deviceIDTextField.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification*)notification {

    NSDictionary *userInfo = notification.userInfo;
    NSValue *endFrameValue = userInfo[UIKeyboardFrameEndUserInfoKey];
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey];

    CGRect keyboardEndFrame = [self.view convertRect:[endFrameValue CGRectValue] fromView:nil];
    NSTimeInterval duration = durationValue.doubleValue;
    NSInteger curve = animationCurve.integerValue;

    NSInteger options = curve << 16;

    float posYDiff = CGRectGetMaxY(self.scrollableView.frame) - CGRectGetMinY(keyboardEndFrame);
    self.bottomSpaceConstraint.constant = MAX(posYDiff + 30, 0);

    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];

}

- (void)keyboardWillHide:(NSNotification*)notification {

    NSDictionary *userInfo = notification.userInfo;

    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey];

    NSTimeInterval duration = durationValue.doubleValue;
    NSInteger curve = animationCurve.integerValue;

    NSInteger options = curve << 16;

    self.bottomSpaceConstraint.constant = 0;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];

}

#pragma mark - Handful methods

- (BOOL)formIsValid {

    NSString *errorMessage;
    if (self.deviceNameTextField.text.length == 0) {
        errorMessage = @"Device name is missing.";
    }

    if (errorMessage) {
        [FMPHelpers shakeView:self.deviceNameTextField showingBorder:YES];
        [SVProgressHUD showErrorWithStatus:errorMessage];
        return NO;
    }

    return YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [self.scrollView setContentOffset:CGPointZero animated:YES];

    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:self.deviceNameTextField]) {
        [self.deviceDescriptionTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    textField.layer.borderWidth = 0;

    return YES;
}

#pragma mark - IBActions

- (IBAction)submitButtonClicked:(id)sender {

    if (![self formIsValid]) {
        return;
    }

    [FMPApiController addDeviceWithName:self.deviceNameTextField.text password:self.deviceDescriptionTextField.text vendorID:self.deviceIDTextField.text completionHandler:^(BOOL success, NSError *error) {
        if (success) {

            FMPTestTrackerViewController *newDeviceView = [[UIStoryboard storyboardWithName:@"TestTrackerViewController" bundle:nil] instantiateInitialViewController];
            [AppDelegate setRootViewController:newDeviceView];
            NSLog(@"Dodano urządzenie");
        }
        
    }];

}

- (IBAction)logoutButtonClicked:(id)sender {

    [FMPApiController logout];

}
@end
