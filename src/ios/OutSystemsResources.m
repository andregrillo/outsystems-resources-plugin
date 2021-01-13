/********* OutSystemsResources.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface OutSystemsResources : CDVPlugin {
  // Member variables go here.
}

- (void)getFile:(CDVInvokedUrlCommand*)command;
@end

@implementation OutSystemsResources

- (void)getFile:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* fileName = [command.arguments objectAtIndex:0];

    if (fileName != nil && [fileName length] > 0) {

    	NSString *openFile ;
	    NSFileManager *fileManager = [NSFileManager defaultManager];
	    NSError *error;
	    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	    NSString *documentsDirectory = [paths objectAtIndex:0];

	        NSString *docDirFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", @"outsystems"]];

	        if ([fileManager fileExistsAtPath:docDirFilePath] == NO)
	        {
	            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"outsystems" ofType:@"png"];
	            [fileManager copyItemAtPath:resourcePath toPath:docDirFilePath error:&error];
	            if (error) {
	                NSLog(@"Error on copying file: %@\nfrom path: %@\ntoPath: %@", error, resourcePath, docDirFilePath);
	                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
	            } 
	    }					

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:fileName];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
