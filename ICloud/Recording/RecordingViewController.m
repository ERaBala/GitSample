//
//  RecordingViewController.m
//  ICloud
//
//  Created by Bala on 06/08/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

#import "RecordingViewController.h"
#import "AudioPlayTabelCell.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecordingViewController ()
{
    NSMutableArray * RecordingList;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    NSString * recorderFilePath;
    NSURL * DirectoryURL;
    NSMutableArray * DirectoryArray;
    
}

@property (weak, nonatomic) IBOutlet UIView *recordingView;
@property (weak, nonatomic) IBOutlet UIButton *longPressButtonTrigger;

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DirectoryArray = [[NSMutableArray alloc] init];

    _recordingView.hidden = YES;
    
//  Button Actions
    [_longPressButtonTrigger addTarget:self action:@selector(holdDown) forControlEvents:UIControlEventTouchDown];
    [_longPressButtonTrigger addTarget:self action:@selector(holdRelease) forControlEvents:UIControlEventTouchUpInside];
    [_longPressButtonTrigger addTarget:self action:@selector(holdReleaseOutSide) forControlEvents:UIControlEventTouchUpOutside]; //add this for your case releasing the finger out side of the button's frame
    
}

-(NSURL *)startPreparToRecord {
    // Set the audio file
    
    NSUInteger r = arc4random_uniform(999);
    NSLog(@"Randoim number - %lu",(unsigned long)r);
    NSString *FileName = [NSString stringWithFormat: @"MyAudioMemo%ld.m4a", (long)r];

    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],FileName,nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    NSLog(@"%@",outputFileURL);
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];

    return outputFileURL;
}

- (void)holdDown
{
    DirectoryURL = [self startPreparToRecord];
    NSLog(@"%@",DirectoryURL);
    
    NSLog(@"hold Down - Start Recording");
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    // Start recording
    [recorder record];
    [_longPressButtonTrigger setTitle:@"Send" forState:UIControlStateNormal];
    
    [UIView transitionWithView:_recordingView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _recordingView.hidden = NO;
                    }
                    completion:NULL];
}

- (void)holdRelease
{
    [self stopTheRecording];
    NSLog(@"hold release - Stop Recording");
}


- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
    [DirectoryArray addObject:DirectoryURL];
    [_tableView reloadData];
    NSLog(@"List of Array -- %@",DirectoryArray);
    NSLog(@"over over");
}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"Done Play");
}

//add this method along with other methods
- (void)holdReleaseOutSide
{
    [self stopTheRecording];
    NSLog(@"hold release out side - Cancel the Recording");
}

-(void) stopTheRecording{

    [UIView transitionWithView:_recordingView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _recordingView.hidden = YES;
                    }
                    completion:NULL];
    
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    
    // Stop the Recording
    [recorder stop];
    [_longPressButtonTrigger setTitle:@"Record" forState:UIControlStateNormal];
}


- (IBAction)playTapped:(id)sender {
    
    NSURL * urls = DirectoryArray[1];
    
    if (!recorder.recording){
        NSLog(@"%@",recorder.url);
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:urls error:nil];
        
        [player setDelegate:self];
        [player play];
        
    }
}

- (IBAction)recordingStartButton:(id)sender {
    
    NSLog(@"button Press");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count");
    return [DirectoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"cell";
    
    AudioPlayTabelCell *cell = (AudioPlayTabelCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSString * FileName = [DirectoryArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = @"namess" ;
    
    return cell;
}

@end
