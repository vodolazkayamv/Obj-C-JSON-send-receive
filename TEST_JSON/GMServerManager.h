//
//  GMServerManager.h
//  iWish
//
//  Created by Водолазкий В.В. on 20/10/14.
//  Copyright (c) 2014 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMServerManager : NSObject

#define DICT_REG_ID				@"id"
#define DICT_REG_NAME			@"name"
#define DICT_REG_NICKNAME		@"nickname"
#define DICT_REG_EMAIL			@"email"
#define DICT_REG_CREATED_AT		@"created_at"
#define DICT_REG_UODATED_AT		@"updated_at"
#define DICT_REG_FBID           @"facebook_id"

#define DICT_TOKEN_ACCESS_TOKEN	@"access_token"
#define DICT_TOKEN_EXPIRES_AT	@"expires_in"




- (void) getGroupList:(NSString *) aName;


@end
