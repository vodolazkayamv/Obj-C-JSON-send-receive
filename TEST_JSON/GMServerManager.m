//
//  GMServerManager.m
//  iWish
//
//  Created by Водолазкий В.В. on 20/10/14.
//  Copyright (c) 2014 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "GMServerManager.h"
#import "UPUtility.h"
#import "AppDelegate.h"
#import "Student.h"
#import "TESTJSONTableViewController.h"

#define IWISH_HOST		@"imac-maria.local"					// Host для заголовков запроса
#define REQUEST_URL		@"http://imac-maria.local/"			// точка доступа к серверу



typedef enum {
	GMGetGroupList = 0,
	
} GMComanndCodes;

@interface GMServerManager () {
	NSMutableArray *receivedDatas;
	NSMutableArray *connections;
	NSMutableArray *requestCodes;
}

@end

@implementation GMServerManager

-(id) init {
	if ( self = [super init] ) {
		receivedDatas = [NSMutableArray arrayWithCapacity:0];
		connections = [NSMutableArray arrayWithCapacity:0];
		requestCodes = [NSMutableArray arrayWithCapacity:0];
		
    
	}
	return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSInteger index = [connections indexOfObject:connection];
	NSAssert( index != NSNotFound, @"unknown connection");
	if (index == NSNotFound) {
		NSLog(@"didReceiveData - connection = %@  %@",[connection originalRequest], [connection currentRequest]);
	}
	
	NSMutableData* receivedData = [receivedDatas objectAtIndex:index];
	
	[receivedData appendData:data];
	//	NSLog(@"did receive data -- index = %d",index);
}


#pragma mark -

- (void) spawnRequestToURL:(NSString *)aUrl withRequestCode:(GMComanndCodes) aCode andData:(NSData *)aData
{
	[self spawnRequestToURL:aUrl withRequestCode:aCode andData:aData asPut:NO];
}

- (void) spawnPutRequestToURL:(NSString *)aUrl withRequestCode:(GMComanndCodes) aCode andData:(NSData *)aData
{
	[self spawnRequestToURL:aUrl withRequestCode:aCode andData:aData asPut:YES];
}

- (void) spawnRequestToURL:(NSString *)aUrl withRequestCode:(GMComanndCodes) aCode andData:(NSData *)aData asPut:(BOOL) aPut
{
	NSMutableData* data = [[NSMutableData alloc] initWithLength:0];
	
	NSString *fullURL = [NSString stringWithFormat:@"%@%@",REQUEST_URL,aUrl];
	NSURL* url = [NSURL URLWithString:fullURL];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	[request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
	[request setTimeoutInterval:60.0];
	if (aData) {
		[request setValue:@"application/json"  forHTTPHeaderField:@"Content-Type"];
		[request setValue:IWISH_HOST forHTTPHeaderField:@"Host"];
		[request setValue:[NSString stringWithFormat:@"%ld",(unsigned long)[aData length]] forHTTPHeaderField:@"Content-Length"];
		[request setHTTPMethod:(aPut? @"PUT" :@"POST")];
		[request setHTTPBody:aData];
	}
	
	DLog(@"request = %@",request);
	
	//	if (aCode == 1111) {
	//		NSLog(@"URL = %@",url);
			NSLog(@"headers   %@", [request allHTTPHeaderFields]);
			NSData* tdata = [request HTTPBody];
			NSString* logStr = [[NSString alloc] initWithBytes:[tdata bytes]
														 length:[tdata length]
												   encoding:NSUTF8StringEncoding];
			NSLog(@"body   %@", logStr);
	//
	//	}
	
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:FALSE];
	
	[receivedDatas addObject:data];
	[connections addObject:connection];
	[connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
	[connection start];
	
	// устанавливаем идентификатор соединения
	[requestCodes addObject:[NSNumber numberWithInteger:aCode]];
	//	NSLog(@"Запущено как запрос - %ld",[requestCodes count]);
}




/*
 curl -i http://iwish.warpc.ru/oauth/token
 -F grant_type=client_credentials
 -F username=voldemarus@narod.ru
 -F password=gondurasovo
 -F client_id=65268c855a7181a3b87cf5e4b89f7b94d9ed1d3283cfebe145f5e423fc2516f1
 -F client_secret=7a20d18cd36fffa36a1a0ce5f13df5b24de93f7478aa0ffc9016d47d892e2a79
 
 */

- (void) getGroupList:(NSString *) aName
{

	NSDictionary *paramDict = @{
                                @"groupName" : aName
								};
	
	NSError *error = nil;
	NSData* jsonData = [NSJSONSerialization dataWithJSONObject:paramDict
													   options:NSJSONWritingPrettyPrinted error:&error];
	if (error) {
		DLog(@"Cannot create JSON packet - %@", [error localizedDescription]);
		return;
	}
	[self spawnRequestToURL:@"/cgi-bin/get_group_list.pl" withRequestCode:GMGetGroupList andData:jsonData];
	
}

#pragma mark - iWish

/*
 POST /import_address_book
 {
 "md5_emails": [
 "c9276a1d37ce2fbe126de042a13f086f",
 "475f414c398fbc9c910e407df8c8ed71"
 ],
 "access_token": "a6f565c5004ce0748e423de5eb54ee1ff503cfc53e8c20ecffd76ac5ba7c649b",
 "user": {}
 }
 */




#pragma mark -


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSInteger index = [connections indexOfObject:connection];
	NSAssert( index != NSNotFound, @"unknown connection");
	
	[connections removeObjectAtIndex:index];
	[receivedDatas removeObjectAtIndex:index];
	[requestCodes removeObjectAtIndex:index];
	
	DLog(@"Connection error 1");
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	NSAssert(connection, @"Connection should be present");
	NSAssert(connections, @"connections array should be valid");
	NSInteger index = [connections indexOfObject:connection];
	NSAssert( index != NSNotFound, @"unknown connection");
	DLog(@"connection fails with error - %@",[error description]);
	if (index) {
		ALog(@"error = %@", [error localizedDescription]);
		
		// Inform delegate about network problem
		[[NSNotificationCenter defaultCenter] postNotificationName:WCFNetworkError object:error];
		
		[connections removeObjectAtIndex:index];
		[receivedDatas removeObjectAtIndex:index];
		[requestCodes removeObjectAtIndex:index];
		
		ALog(@"removed data on connection  - %ld",(long)index);
		
	}
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSInteger index = [connections indexOfObject:connection];
	NSAssert( index != NSNotFound, @"unknown connection");
	
	//	NSRange range;
	
	//	if ( [[dataDays objectAtIndex:index] intValue] != 19 ) return;
	//	NSLog(@"Закончено соединение - %d код - %d",index, [[requestCodes objectAtIndex:index] intValue]);
	//	NSLog(@"коды %@",requestCodes);
	switch ([[requestCodes objectAtIndex:index] intValue]) {
		case GMGetGroupList:				[self processGetGroupList:index]; break;
		
	}
	
	// Удаляем данные о соединении и параметрах
	[connections removeObjectAtIndex:index];
	[receivedDatas removeObjectAtIndex:index];
	[requestCodes removeObjectAtIndex:index];
}


- (void) processGetGroupList:(NSInteger) index
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	
    NSMutableData* receivedData = [receivedDatas objectAtIndex:index];
	
    NSString* text = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	ALog(@"text JSON received on request OK \n");
    ALog(@"processRegister request:\n %@ \n", text);
	
    NSError *error = nil;
	
	NSArray *retData = nil;
	retData= [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&error];
	if (!retData && error) {
		DLog(@"Error during Register Request - %@",[error localizedDescription]);
		
		return;
	}
    ALog(@"retData recieved OK \n");
	//ALog(@"retData = %@",retData);
	
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LoadedStudentsData object:retData];
    

}


@end
