//
//  ViewController.m
//  ICloud
//
//  Created by Bala on 26/07/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIDocumentPickerDelegate>
{

    NSMutableArray * finalPhoneNumber;
    NSMutableArray * pFilesArray;

}
@end

@implementation ViewController


- (IBAction)ICloudTrigger:(id)sender {
  
    UIDocumentPickerViewController * documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"public.plain-text",@"public.composite-content"]inMode:UIDocumentPickerModeImport];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPicker animated:YES completion:nil];

    /*
     Check this Site For Access More Formats -
     https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
    */
    
}

- (void)documentPicker:(UIDocumentPickerViewController* )controller didPickDocumentAtURL:(NSURL* )url
{
    if (controller.documentPickerMode == UIDocumentPickerModeImport)
    {
        
        NSArray     * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString    * documentsDirectory = [paths objectAtIndex:0];
        NSString    * filePath = [documentsDirectory stringByAppendingPathComponent:[url lastPathComponent]];
        
        NSLog(@"%@",filePath);
        
        [url startAccessingSecurityScopedResource];
        __block NSData *pdfData = nil;
        
        NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] init];
        __block NSError *errorss;
        
        [coordinator coordinateReadingItemAtURL:url options:0 error:&errorss byAccessor:^(NSURL *newURL) {
            pdfData = [NSData dataWithContentsOfURL:newURL];
            
            NSString *myString = [[NSString alloc] initWithData:pdfData encoding:NSUTF8StringEncoding];
            NSArray * listItems = [myString componentsSeparatedByString:@","];
            
            for (int i = 0 ; i<listItems.count; i++)
            {
                if (!([[listItems objectAtIndex:i] isEqualToString:@""]))
                {
                    NSLog(@"%@",[listItems objectAtIndex:i]);
/*                  NSString * str = [[[listItems objectAtIndex:i] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
                    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
                    BOOL isDecimal =  [nf numberFromString:str];
                    if (isDecimal == YES)
                    {
                        [finalPhoneNumber addObject:str];
                    }
 */
                }
            }
            NSLog(@"%@",finalPhoneNumber);
            NSPredicate * pred = [NSPredicate predicateWithBlock:^BOOL(id str, NSDictionary* unused) {
                return ![str isEqualToString:@""];
            }];
        }];
        [url stopAccessingSecurityScopedResource];
    }
}

- (void)documentMenu:(UIDocumentMenuViewController* )documentMenu didPickDocumentPicker:(UIDocumentPickerViewController* )documentPicker {
    documentPicker.delegate = self;
    [self presentViewController:documentPicker animated:YES completion:nil];
}

@end
