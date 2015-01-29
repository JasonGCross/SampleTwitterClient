//
//  MockWebService.h
//  SampleTwitterClient
//
//  Created by Jason Cross on 1/29/15.
//  Copyright (c) 2015 Jason Cross. All rights reserved.
//
//  Purpose: This class takes the place of a ServiceLayer, which would act as
//    an adapter for a real web service. The client does not need to know
//    how to access the Web Service; the client simply makes requests to the
//    ServiceLayer, and receives a response.

#import <Foundation/Foundation.h>

typedef void (^WebServiceLoginResponseBlock) (BOOL success, NSError * error);

@interface STCServiceLayer : NSObject

+ (void) loginWithUsername:(NSString*)username password:(NSString*)password responseBlock:(WebServiceLoginResponseBlock)responseBlock;

@end
