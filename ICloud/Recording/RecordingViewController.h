//
//  RecordingViewController.h
//  ICloud
//
//  Created by Bala on 06/08/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordingViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
