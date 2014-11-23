//
//  UCCVideoPlayerView.m
//  UICoreServices
//
//  Created by James Campbell on 06/03/2014.
//  Copyright (c) 2014 Unii. All rights reserved.
//

#import "UCCVideoPlayerView.h"
#import "UIView+AutoLayout.h"
#import "UIImage+Bundle.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

static CGFloat const kControlHeight = 44.0f;

@interface UCCVideoPlayerView ()

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) NSURL * videoUrl;

@property (nonatomic, assign) BOOL initialShowingOfControlsComplete;

@property (nonatomic, strong) UIView *viewControls;

@property (nonatomic, strong, readwrite) UIButton *buttonPlay;
@property (nonatomic, strong, readwrite) UIButton *buttonPause;

@property (nonatomic, strong, readwrite) UILabel *labelCurrentTime;
@property (nonatomic, strong, readwrite) UILabel *labelTotalTime;

@property (nonatomic, strong, readwrite) UISlider *sliderScrubber;

@property (nonatomic, assign, getter = isDragging) BOOL dragging;

@property (nonatomic, strong) id timeObserver;

@property (nonatomic, strong) NSTimer *inactivityTimer;

@property (nonatomic, assign) BOOL showingControls;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

- (void)showControls;
- (void)hideControls;

- (void)loadAssetFromFileAndPlay;
- (void)tapped:(id)sender;

- (void)playButtonPressed:(id)sender;
- (void)pauseButtonPressed:(id)sender;

- (void)sliderDragged:(id)sender;

- (void)inactivityTimerTriggered:(NSTimer *)timer;

- (NSString *)styleTime:(NSUInteger)time;

@end

@implementation UCCVideoPlayerView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.player = [[AVPlayer alloc] init];
        self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        [self.player addObserver:self
                      forKeyPath:@"currentItem"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
        
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        
        [self.layer addSublayer:self.playerLayer];
        
        /*-------------------*/
        
        [self addGestureRecognizer:self.tapGestureRecognizer];
        
        /*-------------------*/
        
        self.enableAudio = YES;
        self.enableTapToControl = NO;
        
        /*-------------------*/
        
        self.fadeOutControlsTimeInterval = 3.0;
        
        /*-------------------*/
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[self.player currentItem]];
    }
    
    return self;
}

#pragma mark - Layout

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    /*-------------------*/
    
    CGFloat yPosition = 0.0f;
    CGFloat height = self.frame.size.height;
    
    if (self.enableControls &&
        self.enableControlsPadding)
    {
        yPosition = kControlHeight;
        height -= (2*kControlHeight);
    }
    
    //AVPlayerLayer animates bound changes which can cause glitches as these animations queue up, this CATransaction makes sure all transitions are diabled to prevent any animation queue build ups.
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    [CATransaction setDisableActions:YES];
    self.playerLayer.frame = CGRectMake(0.0f,
                                        yPosition,
                                        self.frame.size.width,
                                        height);
    [CATransaction commit];
}

#pragma mark - SubViews

- (UIView *)viewControls
{
    if(!_viewControls)
    {
        _viewControls = [UIView newAutoLayoutView];
        _viewControls.alpha = 0.0f;
        
        /*-------------------*/
        
        [_viewControls addSubview:self.sliderScrubber];
        [_viewControls addSubview:self.buttonPause];
        [_viewControls addSubview:self.buttonPlay];
        [_viewControls addSubview:self.labelTotalTime];
        [_viewControls addSubview:self.labelCurrentTime];
        
        /*-------------------*/
        
        [self.buttonPlay autoSetDimension:ALDimensionWidth
                                   toSize:44.0f];
        
        [self.buttonPlay autoSetDimension:ALDimensionHeight
                                   toSize:44.0f];
        
        [self.buttonPlay autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                          withInset:00.0f];
        
        [self.buttonPlay autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        /*-------------------*/
        
        [self.buttonPause autoSetDimension:ALDimensionWidth
                                    toSize:44.0f];
        
        [self.buttonPause autoSetDimension:ALDimensionHeight
                                    toSize:44.0f];
        
        [self.buttonPause autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                           withInset:0.0f];
        
        [self.buttonPause autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        /*-------------------*/
        
        [self.labelCurrentTime autoSetDimension:ALDimensionHeight
                                         toSize:self.labelCurrentTime.font.lineHeight];
        
        [self.labelCurrentTime autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.labelCurrentTime autoPinEdge:ALEdgeLeft
                                    toEdge:ALEdgeRight
                                    ofView:self.buttonPlay
                                withOffset:0.0f];
        
        /*-------------------*/
        
        [self.sliderScrubber autoPinEdge:ALEdgeLeft
                                  toEdge:ALEdgeRight
                                  ofView:self.labelCurrentTime
                              withOffset:10.0f];
        
        [self.sliderScrubber autoPinEdge:ALEdgeRight
                                  toEdge:ALEdgeLeft
                                  ofView:self.labelTotalTime
                              withOffset:-10.0f];
        
        [self.sliderScrubber autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        /*-------------------*/
        
        [self.labelTotalTime autoSetDimension:ALDimensionHeight
                                       toSize:self.labelTotalTime.font.lineHeight];
        
        [self.labelTotalTime autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.labelTotalTime autoPinEdgeToSuperviewEdge:ALEdgeRight
                                              withInset:10.0f];
        
        /*-------------------*/
        
        
    }
    
    return _viewControls;
}

- (UIButton *)buttonPlay
{
    if (!_buttonPlay)
    {
        _buttonPlay = [UIButton newAutoLayoutView];
        _buttonPlay.hidden = YES;
        
        [_buttonPlay addTarget:self
                        action:@selector(playButtonPressed:)
              forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _buttonPlay;
}


- (UIButton *)buttonPause
{
    if (!_buttonPause)
    {
        _buttonPause = [UIButton newAutoLayoutView];
        _buttonPause.hidden = NO;
        
        [_buttonPause addTarget:self
                         action:@selector(pauseButtonPressed:)
               forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _buttonPause;
}

- (UISlider *)sliderScrubber
{
    if (!_sliderScrubber)
    {
        _sliderScrubber = [UISlider newAutoLayoutView];
        _sliderScrubber.minimumTrackTintColor = [UIColor whiteColor];
        _sliderScrubber.maximumTrackTintColor = [UIColor lightGrayColor];
        
        _sliderScrubber.minimumValue = 0.0f;
        _sliderScrubber.value = 0.0f;
        
        [_sliderScrubber addTarget:self
                            action:@selector(sliderDragged:)
                  forControlEvents:UIControlEventTouchDragInside];
        
        [_sliderScrubber addTarget:self
                            action:@selector(sliderTouchEnd:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sliderScrubber;
}

- (UILabel *)labelCurrentTime
{
    if (!_labelCurrentTime)
    {
        _labelCurrentTime = [UILabel newAutoLayoutView];
        _labelCurrentTime.textAlignment = NSTextAlignmentCenter;
    }
    
    return _labelCurrentTime;
}

- (UILabel *)labelTotalTime
{
    if (!_labelTotalTime)
    {
        _labelTotalTime = [UILabel newAutoLayoutView];
        _labelTotalTime.textAlignment = NSTextAlignmentCenter;
    }
    
    return _labelTotalTime;
}

#pragma mark - Scaling

- (void) setScalingMode:(UCCVideoScalingMode)scalingMode
{
    [self willChangeValueForKey:@"scalingMode"];
    _scalingMode = scalingMode;
    [self didChangeValueForKey:@"scalingMode"];
    
    /*-------------------*/
    
    switch (scalingMode)
    {
        case UCCVideoScalingModeAspectFill:
        {
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            
            break;
        }
        case UCCVideoScalingModeAspectFit:
        {
            
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            
            break;
        }
        case UCCVideoScalingModeFill:
        {
            self.playerLayer.videoGravity = AVLayerVideoGravityResize;
            
            break;
        }
    }
}

#pragma mark - Loading

- (void)loadItemFromURL:(NSURL *)url
{
    self.videoUrl = url;
    [self loadAssetFromFileAndPlay];
}

- (void)loadItemFromData:(NSData *)data
{
    
    if ([self.delegate respondsToSelector:@selector(playerWillLoad)])
    {
        [self.delegate playerWillLoad];
    }
    
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
#pragma warning Unhardcode these
    cachesPath = [cachesPath stringByAppendingPathComponent:@"Unii"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachesPath isDirectory:nil])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
#pragma warning Unhardcode these
    NSString *filePath = [cachesPath stringByAppendingPathComponent:@"LatestMovie.mov"];
    
    [[NSFileManager defaultManager] createFileAtPath:filePath
                                            contents:data
                                          attributes:nil];
    
    self.videoUrl = [NSURL fileURLWithPath:filePath];
    [self loadAssetFromFileAndPlay];
}

- (void)loadAssetFromFileAndPlay
{
    self.backgroundColor = [UIColor blackColor];
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.videoUrl options:nil];
    NSString *tracksKey = @"tracks";
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    [asset loadValuesAsynchronouslyForKeys:@[tracksKey]
                         completionHandler:^
     {
         
         dispatch_async(dispatch_get_main_queue(),^
                        {
                            
                            NSError *error = nil;
                            AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];
                            
                            if (status == AVKeyValueStatusLoaded)
                            {
                                
                                self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
                                [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
                                
                                if (self.enableAutoPlayBack)
                                {
                                    [self play];
                                }
                                
                                if ( [self.delegate respondsToSelector:@selector(playerDidLoadAsset:)] )
                                {
                                    [self.delegate playerDidLoadAsset: asset];
                                }
                                
                                if (self.enableControls)
                                {
                                    Float64 duraton = CMTimeGetSeconds(asset.duration);
                                    
                                    self.sliderScrubber.maximumValue = duraton;
                                    self.labelTotalTime.text = [self styleTime:(NSUInteger)duraton];
                                    self.labelCurrentTime.text = [self styleTime:0];
                                }
                            }
                            else
                            {
                                
                                if ( [self.delegate respondsToSelector:@selector(playerDidFailToLoad:)] )
                                {
                                    [self.delegate playerDidFailToLoad: error];
                                }
                                
                                NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
                            }
                        });
     }];
}

#pragma mark - UITapGestureRecognizer

- (UITapGestureRecognizer *) tapGestureRecognizer
{
    if (!_tapGestureRecognizer)
    {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(tapped:)];
    }
    
    return _tapGestureRecognizer;
}

- (void)tapped:(id)sender
{
    if (self.enableTapToControl)
    {
        if (self.isPlaying)
        {
            [self pause];
        }
        else
        {
            [self play];
        }
    }
    
    if (self.enableControls)
    {
        if (self.showingControls)
        {
            [self stopInactivityTimer];
            [self hideControls];
        }
        else
        {
            [self showControls];
            [self startInactivityTimer];
        }
    }
    
    if([self.delegate respondsToSelector:@selector(playerWasTapped)])
    {
        [self.delegate playerWasTapped];
    }
}

#pragma mark - Controls

- (void)setEnableControls:(BOOL)enableControls
{
    if (_enableControls != enableControls)
    {
        [self willChangeValueForKey:@"enableControls"];
        _enableControls = enableControls;
        [self didChangeValueForKey:@"enableControls"];
        
        if (_enableControls)
        {
            /*-------------------*/
            
            [self addSubview:self.viewControls];
            
            /*-------------------*/
            
            [self.viewControls autoSetDimension:ALDimensionHeight
                                         toSize:kControlHeight];
            
            [self.viewControls autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                                withInset:0.0f];
            
            [self.viewControls autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                withInset:0.0f];
            
            [self.viewControls autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                                withInset:0.0f];
            
            /*-------------------*/
            
            [self showControls];
        }
        else
        {
            [self.viewControls removeFromSuperview];
        }
        
    }
}

- (void)setEnableControlsPadding:(BOOL)enableControlsPadding
{
    if (_enableControlsPadding != enableControlsPadding)
    {
        [self willChangeValueForKey:@"enableControlsPadding"];
        _enableControlsPadding = enableControlsPadding;
        [self didChangeValueForKey:@"enableControlsPadding"];
        
        /*-------------------*/
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)playButtonPressed:(id)sender
{
    [self play];
}

- (void)pauseButtonPressed:(id)sender
{
    [self pause];
}

- (void)sliderDragged:(id)sender
{
    self.dragging = YES;
    
    [self pause];
    
    [self.player seekToTime:CMTimeMakeWithSeconds(self.sliderScrubber.value, USEC_PER_SEC)];
}

- (void)sliderTouchEnd:(id)sender
{
    self.dragging = NO;
    
    [self.player seekToTime:CMTimeMakeWithSeconds(self.sliderScrubber.value, USEC_PER_SEC)
            toleranceBefore:kCMTimeZero
             toleranceAfter:kCMTimeZero];
    
    [self play];
}

- (void)showControls
{
    [UIView animateWithDuration:0.2
                     animations:^
     {
         self.viewControls.alpha = 1.0f;
     }
                     completion:^(BOOL finished)
     {
         self.showingControls = YES;
     }];
}

- (void)hideControls
{
    [UIView animateWithDuration:0.2
                     animations:^
     {
         self.viewControls.alpha = 0.0f;
     }
                     completion:^(BOOL finished)
     {
         self.showingControls = NO;
     }];
}

#pragma mark - TimeStyling

- (NSString *)styleTime:(NSUInteger)time
{
    NSInteger seconds = time % 60;
    NSInteger minutes = (time / 60) % 60;
    
    return [NSString stringWithFormat:@"%ld:%02ld", (long)minutes, (long)seconds];
}

#pragma mark - Timer

- (void)startSliderTimer
{
    if (!self.timeObserver)
    {
        [self.sliderScrubber setValue:CMTimeGetSeconds(self.player.currentItem.currentTime)
                             animated:NO];
        
        __weak typeof(self) weakSelf = self;
        self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0 / 60.0, USEC_PER_SEC)
                                                                      queue:dispatch_get_main_queue()
                                                                 usingBlock:^(CMTime time)
                             {
                                 if (weakSelf.isPlaying &&
                                     !weakSelf.isDragging)
                                 {
                                     Float64 currentTime = CMTimeGetSeconds(time);
                                     
                                     [weakSelf.sliderScrubber setValue:currentTime
                                                              animated:NO];
                                     
                                     weakSelf.labelCurrentTime.text = [weakSelf styleTime:(NSUInteger)currentTime];
                                 }
                             }];
    }
    
}

- (void)stopSliderTimer
{
    [self.timeObserver invalidate];
    self.timeObserver = nil;
}

- (void)startInactivityTimer
{
    if (!self.inactivityTimer)
    {
        self.inactivityTimer = [NSTimer scheduledTimerWithTimeInterval:self.fadeOutControlsTimeInterval
                                                                target:self
                                                              selector:@selector(inactivityTimerTriggered:)
                                                              userInfo:nil
                                                               repeats:NO];
    }
    
}

- (void)stopInactivityTimer
{
    [self.inactivityTimer invalidate];
    self.inactivityTimer = nil;
}

- (void)inactivityTimerTriggered:(NSTimer *)timer;
{
    if (!self.initialShowingOfControlsComplete ||
        self.enableFadeControlsEverytime)
    {
        
        self.initialShowingOfControlsComplete = YES;
        
        [self hideControls];
    }
    
}

#pragma mark - State

- (BOOL)isPlaying
{
    return (self.player.error == nil &&
            self.player.rate != 0);
}

- (BOOL)isMuted
{
    return !self.player.volume;
}

- (void)play
{
    if (self.enableControls)
    {
        [self stopInactivityTimer];
    }
    
    /*-------------------*/
    
    [self.player play];
    
    /*-------------------*/
    
    if (self.enableControls)
    {
        self.buttonPause.hidden = NO;
        self.buttonPlay.hidden = YES;
    }
    
    /*-------------------*/
    
    if ([self.delegate respondsToSelector:@selector(playerStatusDidChange:)])
    {
        [self.delegate playerStatusDidChange:UCCVideoPlaybackStatusPlaying];
    }
    
    /*-------------------*/
    
    if (self.enableControls)
    {
        [self startSliderTimer];
        [self startInactivityTimer];
    }
}

- (void)pause
{
    [self.player pause];
    
    /*-------------------*/
    
    [self stopSliderTimer];
    
    /*-------------------*/
    
    if (self.enableControls)
    {
        self.buttonPlay.hidden = NO;
        self.buttonPause.hidden = YES;
    }
    
    /*-------------------*/
    
    if ([self.delegate respondsToSelector:@selector(playerStatusDidChange:)])
    {
        [self.delegate playerStatusDidChange:UCCVideoPlaybackStatusPaused];
    }
}

#pragma mark - Mute

- (void)mute
{
    self.player.volume = 0;
}

- (void)unmute
{
    self.player.volume = 3;
}

#pragma mark - Notifications

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    if ([notification.object isEqual:self.playerItem])
    {
        if (self.enableLooping)
        {
            [self.player seekToTime:kCMTimeZero];
            [self play];
            
            if ([self.delegate respondsToSelector:@selector(playerStatusDidChange:)])
            {
                [self.delegate playerStatusDidChange:UCCVideoPlaybackStatusLooping];
            }
        }
        else
        {
            [self stopSliderTimer];
            
            [self.player seekToTime:kCMTimeZero];
            [self pause];
            
            [self.sliderScrubber setValue:0
                                 animated:NO];
            
            self.labelCurrentTime.text = [self styleTime:0];
            
            if ([self.delegate respondsToSelector:@selector(playerStatusDidChange:)])
            {
                [self.delegate playerStatusDidChange:UCCVideoPlaybackStatusStopped];
            }
        }
    }
}

#pragma mark - KVO

- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    
    if ([keyPath isEqualToString:@"currentItem"])
    {
        if ([object isEqual:self.player])
        {
            
            if (!self.enableAudio)
            {
                AVAsset *asset = self.player.currentItem.asset;
                NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
                
                NSMutableArray *allAudioParams = [NSMutableArray array];
                
                for (AVAssetTrack *track in audioTracks)
                {
                    AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
                    
                    [audioInputParams setVolume:0.0f
                                         atTime:kCMTimeZero];
                    
                    audioInputParams.trackID = track.trackID;
                    [allAudioParams addObject:audioInputParams];
                }
                
                AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
                [audioZeroMix setInputParameters:allAudioParams];
                
                [self.player.currentItem setAudioMix:audioZeroMix];
            }
        }
    }
}

#pragma mark - MemoryManagement

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.player removeTimeObserver:self.timeObserver];
    
    [self.player removeObserver:self
                     forKeyPath:@"currentItem"];
    
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    
    self.player = nil;
    self.playerLayer = nil;
    self.playerItem = nil;
    self.asset = nil;
}

@end
