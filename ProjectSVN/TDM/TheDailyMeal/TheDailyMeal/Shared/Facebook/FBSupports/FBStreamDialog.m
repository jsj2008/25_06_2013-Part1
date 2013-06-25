/*
 * Copyright 2009 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FBStreamDialog.h"
#import "FBSession.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static NSString* kStreamURL = @"http://www.facebook.com/connect/prompt_feed.php";

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation FBStreamDialog

@synthesize attachment        = _attachment,
		    actionLinks       = _actionLinks,
            targetId          = _targetId,
            userMessagePrompt = _userMessagePrompt;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initialization

- (id)initWithSession:(FBSession*)session {
    self = [super initWithSession:session];
	if (self) {
		_attachment        = @"";
		_actionLinks       = @"";
		_targetId          = @"";
		_userMessagePrompt = @"";
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - FBDialog Overwritten Methods

- (void)load {
    
    NSString *linkString = @"http://blogs.inlandsocal.com/iguide/2011/07/pala-cafe.html";
    
	NSDictionary* getParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               _session.apiKey, @"app_id",
                               linkString, @"link",
                               @"http://www.diario.com.mx/response", @"redirect_uri",
							   @"touch", @"display", nil];
    
    
	
//	NSDictionary* postParams = [NSDictionary dictionaryWithObjectsAndKeys:
//								_session.apiKey,      @"api_key",
//                                linkString,           @"link",
//								_session.sessionKey,  @"session_key",
//								@"1",                 @"preview",
//								@"fbconnect:success", @"callback",
//								@"fbconnect:cancel",  @"cancel",
//								_attachment,          @"attachment",
//								_actionLinks,         @"action_links",
//								_targetId,            @"target_id",
//								_userMessagePrompt,   @"user_message_prompt",
//								nil];
	
	[self loadURL:@"http://www.facebook.com/dialog/feed" method:@"GET" get:getParams post:nil];
}

- (void)dialogDidSucceed:(NSURL*)url {

    if ([url.scheme isEqualToString:@"fbconnect"]) {
        if ([url.resourceSpecifier isEqualToString:@"success"]) {
            [self showAlert:@"Story posted." delegateObject:nil];
        }
    }
    
     [self dismissWithSuccess:YES animated:YES];
}

#pragma mark - Memory Management

- (void)dealloc {
    
	[_attachment        release];
    _attachment = nil;
	[_actionLinks       release];
    _actionLinks = nil;
	[_targetId          release];
    _targetId = nil;
	[_userMessagePrompt release];
    _userMessagePrompt = nil;
    
	[super dealloc];
}

@end
