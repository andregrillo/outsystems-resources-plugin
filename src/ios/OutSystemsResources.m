/********* OutSystemsResources.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface OutSystemsResources : CDVPlugin {
}

- (void)getFile:(CDVInvokedUrlCommand*)command;
@end

@implementation OutSystemsResources

- (void)getFile:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* file = [command.arguments objectAtIndex:0];
    
    if (file != nil && [file length] > 0) {
        
        NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath = [appFolderPath stringByAppendingString:[NSString stringWithFormat:@"/www/%@",file]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *docDirFilePath = [documentsDirectory stringByAppendingPathComponent:file];
        BOOL fileExists = [fileManager fileExistsAtPath:filePath];
        
        if (fileExists) {
            [fileManager copyItemAtPath:filePath toPath:docDirFilePath error:&error];
            if (error) {
                NSLog(@"ERROR: Error on copying file: %@\nfrom path: %@\ntoPath: %@", error, filePath, docDirFilePath);
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:file];
            }
        } else {
            NSLog(@"ERROR: File does not exist");
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"ERROR: File does not exist"];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"ERROR: A file name must be set as a parameter"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
