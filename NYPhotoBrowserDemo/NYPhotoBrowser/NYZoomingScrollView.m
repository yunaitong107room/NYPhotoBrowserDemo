//
//  NYZoomingScrollView.m
//  NYPhotoBrowserDemo
//
//  Created by Naitong Yu on 15/8/8.
//  Copyright (c) 2015年 107间. All rights reserved.
//

#import "NYZoomingScrollView.h"

@interface NYZoomingScrollView () <UIScrollViewDelegate, NYTappableImageViewDelegate>

@property (nonatomic, weak) NYPhotoBrowser *photoBrowser;

@end

@interface NYPhotoBrowser ()
- (void)singleTapOnImage;
@end

@implementation NYZoomingScrollView

- (instancetype)initWithPhotoBrowser:(NYPhotoBrowser *)browser {
    self = [super init];
    if (self) {
        _photoBrowser = browser;
        
        _imageView = [[NYTappableImageView alloc]initWithFrame:CGRectZero];
        _imageView.tapDelegate = self;
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

#pragma mark - tap detection

- (void)handleSingleTap:(CGPoint)touchPoint {
    if (self.zoomScale == self.minimumZoomScale) {
        [self.photoBrowser performSelector:@selector(singleTapOnImage) withObject:nil afterDelay:0.2];
    }
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
    // Cancel any single tap handling
    [NSObject cancelPreviousPerformRequestsWithTarget:_photoBrowser];
    
    // Zoom
    if (self.zoomScale == self.maximumZoomScale) {
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        // Zoom in
        [self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}

- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    [self handleSingleTap:[touch locationInView:imageView]];
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

#pragma mark - image property

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image {
    [self.imageView setImage:image];
    // reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeZero;
    
    if (image) {
        _imageView.hidden = NO;
        CGRect imageViewFrame;
        imageViewFrame.origin = CGPointZero;
        imageViewFrame.size = image.size;
        _imageView.frame = imageViewFrame;
        self.contentSize = imageViewFrame.size;
        [self setMaxMinZoomScalesForCurrentBounds];
    } else {
        _imageView.hidden = YES;
    }
    [self setNeedsLayout];
}

#pragma mark - setup

- (void)setMaxMinZoomScalesForCurrentBounds {
    // reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    if (self.image == nil) {
        return;
    }
    
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _imageView.frame.size;
    
    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // If image is smaller than the screen then ensure we show it at
    // min scale of 1
    if (xScale > 1 && yScale > 1) {
        //minScale = 1.0;
    }
    
    // Calculate Max
    CGFloat maxScale = 4.0; // Allow double scale
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        maxScale = maxScale / [[UIScreen mainScreen] scale];
        
        if (maxScale < minScale) {
            maxScale = minScale * 2;
        }
    }
    
    // Set
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    // reset  position
    _imageView.frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
    [self setNeedsLayout];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_imageView.frame, frameToCenter)) {
        _imageView.frame = frameToCenter;
    }
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
