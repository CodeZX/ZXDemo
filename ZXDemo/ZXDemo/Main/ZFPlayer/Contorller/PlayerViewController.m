//
//  PlayerViewController.m
//  ZXDemo
//
//  Created by 周鑫 on 2018/8/10.
//  Copyright © 2018年 ZX. All rights reserved.
//

#import "PlayerViewController.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>


#import <AVFoundation/AVFoundation.h>

@interface PlayerViewController ()
@property (nonatomic,strong) ZFPlayerController *player;


@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"ZFPlayer";
    self.view.backgroundColor = [UIColor whiteColor];
//    Class<ZFPlayerMediaPlayback> *playerManager = ...;
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc]init];
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager  containerView:self.view];
    self.player.controlView = [[ZFPlayerControlView alloc]init];
    self.player.assetURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    
    
    AVPlayer *player = [[AVPlayer alloc]init];
    player.rate = 1.5;
    AVAudioPlayer *audio = [[AVAudioPlayer alloc]init];
    
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

@end
