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
    NSString* file = [command.arguments objectAtIndex:0];

    if (file != nil && [file length] > 0) {

        NSString *fileExt = [file pathExtension];
        NSString *fileName = [file stringByDeletingPathExtension];
	    NSFileManager *fileManager = [NSFileManager defaultManager];
	    NSError *error;
	    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	    NSString *documentsDirectory = [paths objectAtIndex:0];
	    NSString *docDirFilePath = [documentsDirectory stringByAppendingPathComponent:file];

        if ([fileManager fileExistsAtPath:docDirFilePath] == NO)
        {
            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
            [fileManager copyItemAtPath:resourcePath toPath:docDirFilePath error:&error];
            if (error) {
                NSLog(@"Error on copying file: %@\nfrom path: %@\ntoPath: %@", error, resourcePath, docDirFilePath);
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            } 
	    }					

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:file];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"File name parameter cannot be null or an empty string"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
