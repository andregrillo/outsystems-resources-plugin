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
        BOOL fileExists = [fileManager fileExistsAtPath:docDirFilePath];
        
        if (fileExists) {
            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
            if (resourcePath != nil && [resourcePath length] > 0) {
                [fileManager copyItemAtPath:resourcePath toPath:docDirFilePath error:&error];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:file];
                if (error) {
                    NSLog(@"ERROR: Error on copying file: %@\nfrom path: %@\ntoPath: %@", error, resourcePath, docDirFilePath);
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                }
            } else {
                NSLog(@"ERROR: Invalid file name or file already exists");
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"ERROR: Invalid file name or file already exists"];
            }
        } else {
            NSLog(@"ERROR: File does not exist");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"ERROR: File does not exist"];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
