//
//  UCCVideoPlayerView.h
//  UICoreServices
//
//  Created by James Campbell on 06/03/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/*!
 Defines the status of the Video view.
 */
typedef NS_ENUM(NSUInteger, UCCVideoPlaybackStatus)
{
    /*!
     The Video view is still playing.
     */
    UCCVideoPlaybackStatusPlaying,
    /*!
     The Video view is looping.
     */
    UCCVideoPlaybackStatusLooping,
    /*!
     The Video view is paused.
     */
    UCCVideoPlaybackStatusPaused,
    /*!
     The Video view is stopped.
     */
    UCCVideoPlaybackStatusStopped,
};

/*!
 Defines the sclaing mode
 */
typedef NS_ENUM(NSUInteger, UCCVideoScalingMode)
{
    /*!
     Uniform scale until one dimension fits
     */
    UCCVideoScalingModeAspectFit,
    /*!
     Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
     */
    UCCVideoScalingModeAspectFill,
    /*!
     Non-uniform scale. Both render dimensions will exactly match the visible bounds
     */
    UCCVideoScalingModeFill
};

@protocol UCCVideoPlayerViewDelegate <NSObject>

@optional

- (void)playerStatusDidChange:(UCCVideoPlaybackStatus)status;
- (void)playerDidLoadAsset:(AVAsset *)asset;
- (void)playerWillLoad;
- (void)playerDidFailToLoad:(NSError *)error;
- (void)playerWasTapped;

@end

/*!
 View used to embed and play a video.
 */
@interface UCCVideoPlayerView : UIView

@property(nonatomic, weak) id<UCCVideoPlayerViewDelegate> delegate;

@property (nonatomic, assign) BOOL enableLooping;
@property (nonatomic, assign) BOOL enableAudio;
@property (nonatomic, assign) BOOL enableTapToControl;
@property (nonatomic, assign) BOOL enableControls;
@property (nonatomic, assign) BOOL enableControlsPadding;
@property (nonatomic, assign) BOOL enableFadeControlsEverytime;
@property (nonatomic, assign) BOOL enableAutoPlayBack;
@property (nonatomic, assign) UCCVideoScalingMode scalingMode;

@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) BOOL isMuted;

@property (nonatomic, strong, readonly) UIButton *buttonPlay;
@property (nonatomic, strong, readonly) UIButton *buttonPause;

@property (nonatomic, strong, readonly) UILabel *labelCurrentTime;
@property (nonatomic, strong, readonly) UILabel *labelTotalTime;

@property (nonatomic, strong, readonly) UISlider *sliderScrubber;

@property (nonatomic, assign) NSTimeInterval fadeOutControlsTimeInterval;

- (void)loadItemFromURL:(NSURL *)url;
- (void)loadItemFromData:(NSData *)data;

- (void)play;
- (void)pause;

- (void)mute;
- (void)unmute;

@end
