//
//  AudioPlayTabelCell.h
//  ICloud
//
//  Created by Bala on 07/08/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioPlayTabelCell : UITableViewCell
{
    int ButtonStatus;
}

- (IBAction)playPauseButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *playPauseButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;

@end
