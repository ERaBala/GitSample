//
//  RecordingViewController.m
//  ICloud
//
//  Created by Bala on 06/08/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

#import "RecordingViewController.h"
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RecordingViewController ()
{
    NSMutableArray * RecordingList;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    NSString * recorderFilePath;
}

@property (weak, nonatomic) IBOutlet UIView *recordingView;
@property (weak, nonatomic) IBOutlet UIButton *longPressButtonTrigger;

@end

@implementation RecordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _recordingView.hidden = YES;
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
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
    

//  Button Actions
    [_longPressButtonTrigger addTarget:self action:@selector(holdDown) forControlEvents:UIControlEventTouchDown];
    [_longPressButtonTrigger addTarget:self action:@selector(holdRelease) forControlEvents:UIControlEventTouchUpInside];
    [_longPressButtonTrigger addTarget:self action:@selector(holdReleaseOutSide) forControlEvents:UIControlEventTouchUpOutside]; //add this for your case releasing the finger out side of the button's frame
    
}

- (void)holdDown
{
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
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}

- (IBAction)recordingStartButton:(id)sender {
    
    NSLog(@"button Press");
}

@end