//
//  BuildTestViewcontrollerViewController.m
//  Fred_Ralph_Final
//
//  Created by Rafael Flores on 4/25/16.
//  Copyright © 2016 MAE. All rights reserved.
//

#import "BuildTestViewcontrollerViewController.h"
#import "OutputManager.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "JWebHandler.h"
#import "JNode.h"

@interface BuildTestViewcontrollerViewController () <MFMailComposeViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerFormat;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnDropbox;
@property (weak, nonatomic) IBOutlet UIButton *btnGist;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedFiles;
@property (weak, nonatomic) IBOutlet UIWebView *webPreviewCode;


@property (strong, nonatomic) NSDictionary *supportedOutputFormats;
@property (strong, nonatomic) NSString *selectedOutputFormat;

@end

@implementation BuildTestViewcontrollerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.supportedOutputFormats = @{ @"Objective-C" : [ObjectiveCOutputFormatter new],
                                     @"Swift" : [SwiftOutputFormatter new],
                                     @"C#" : [SwiftOutputFormatter new] //to see more than two in the pickerview
                                     };
    
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"TestCode" ofType:@"html" inDirectory:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:htmlFile];
    [self.webPreviewCode loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return 3;
    
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
    return self.supportedOutputFormats.allKeys[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.selectedOutputFormat = self.supportedOutputFormats.allKeys[row];
    
    //set the selected output formatter to the output
    //self.[self.supportedOutputFormats objectForKey:selectedElement];

}


#pragma mark  -  email
-(IBAction) displayComposerSheet:(UIButton*) sender
{
    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
    mailView.mailComposeDelegate = self;
    [mailView setSubject:@"API Crossroads for iOS! Output Generated for "];
    
    // Set up recipients
    // NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    // [picker setToRecipients:toRecipients];
    // [picker setCcRecipients:ccRecipients];
    // [picker setBccRecipients:bccRecipients];
    
    
    //attah a textfile
    
    
    //get the output manager and files that are required for this output
    //[mailView addAttachmentData:myData mimeType:@"text/plain" fileName:@"APIWebHandler.h"];
    
    JWebHandler *handler =  [JWebHandler sharedJWebHandler];
    OutputManager *outputManager = [OutputManager new];
    outputManager.delegateOutput = [self.supportedOutputFormats objectForKey:self.selectedOutputFormat];
    
    //outputManager s
    
    // Fill out the email body text
    NSString *emailBody = [NSString stringWithFormat: @"Code generated by APICrossroads. \n API URL: %@", handler.webString];
    
    
    [mailView setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:mailView animated:YES completion:NULL];
    
    
    
    
    
}


//dropbox api
static NSString *DB_APP_KEY = @"v991hk6igzntpg2";
static NSString *DB_APP_SECRET = @"cyo81nfpn67n8tu";

#pragma mark - dropbox
- (IBAction)saveToDropbox:(id)sender {
    
    
    
}



- (IBAction)addResultToFavorites:(id)sender {
}

- (IBAction)copyTextFileToClipboard:(id)sender {
}

@end
