//
//  CRFeedbackDialog.h
//  Critizr
//
//  Created by Ludovic Loridan on 2/25/15.
//  Copyright (c) 2015 Critizr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRFeedbackDialogDelegate <NSObject>

@optional

- (void) feedbackDialogDidCloseWithMessageSent:(BOOL)messageSent;

@end

@interface CRFeedbackDialog : NSObject

+ (CRFeedbackDialog *) feedbackDialog;

- (void) presentFeedbackDialogFrom:(UIViewController *) viewController withParams:(NSDictionary *)params;
- (void) presentFeedbackDialogFrom:(UIViewController *) viewController withStoreId:(int)storeId withParams:(NSDictionary *)params;
- (void) presentFeedbackDialogFrom:(UIViewController *) viewController withStoreIdString:(NSString *)storeId withParams:(NSDictionary *)params;


@end
