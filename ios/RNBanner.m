#import "RNBanner.h"
#import "TSCToastView.h"
#import "TSCToastNotificationController.h"

@implementation RNBanner

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(showToastWithTitle:(NSString *)title)
{
    TSCToastView *toastNotification = [TSCToastView toastNotificationWithTitle:title message:nil image:nil];
    [[TSCToastNotificationController sharedController] displayToastNotificationView:toastNotification];
}

@end
