//
//  CRSdk.h
//  Critizr
//
//  Created by Thibaut Carlier on 07/07/2015.
//  Copyright (c) 2015 Critizr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CRSdkDelegate <NSObject>
@optional
- (void)critizrPlaceRatingFetched:(double)aPlaceRating;
- (void)critizrPlaceRatingError:(NSError *)anError;
@end

@interface CRSdk : NSObject {
    
}
@property (weak)  id<CRSdkDelegate> delegate;

+ (CRSdk *)sharedInstance;
+ (CRSdk *)critizrSDKInstance:(id<CRSdkDelegate>)delegate;
- (NSString *)getApiKey;

- (void)fetchRatingForPlace:(NSString *)aPlaceId withDelegate:(id<CRSdkDelegate>)aDelegate;

- (NSURL *)urlForStoreLocatorRessource:(NSDictionary *)params;

- (NSURL *)urlForWidgetRessourceForStroreId:(NSString *)storeId withParams:(NSDictionary *) params;

@end

