//
//  AudioPlayTabelCell.m
//  ICloud
//
//  Created by Bala on 07/08/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

#import "AudioPlayTabelCell.h"

@implementation AudioPlayTabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ButtonStatus = 0;
    [_playPauseButtonOutlet setImage:[UIImage imageNamed:@"video-play-icon.png"] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playPauseButton:(id)sender {

    NSLog(@"%@",sender);
    if (ButtonStatus == 0) {
        [_playPauseButtonOutlet setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        ButtonStatus = 1;
    }
    else{
        [_playPauseButtonOutlet setImage:[UIImage imageNamed:@"video-play-icon.png"] forState:UIControlStateNormal];
        ButtonStatus = 0;
    }
    
}

@end
