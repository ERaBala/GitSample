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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DonePlay:) name:@"DonePlay" object:nil];

}

-(void) DonePlay:(NSNotification *) notification
{
    [_playPauseButtonOutlet setImage:[UIImage imageNamed:@"video-play-icon.png"] forState:UIControlStateNormal];
    ButtonStatus = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playPauseButton:(id)sender {
   
    NSString * row = [NSString stringWithFormat:@"%ld", _playPauseButtonOutlet.tag];
    NSLog(@"%@",sender);
    NSDictionary *dict = [NSDictionary dictionaryWithObject:row forKey:@"TableViewCellRow"];
    
    if (ButtonStatus == 0) {
        [_playPauseButtonOutlet setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        ButtonStatus = 1;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayNotification" object:self userInfo:dict];
    }
    else{
        [_playPauseButtonOutlet setImage:[UIImage imageNamed:@"video-play-icon.png"] forState:UIControlStateNormal];
        ButtonStatus = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PauseNotification" object:self];

    }
    
}

@end
