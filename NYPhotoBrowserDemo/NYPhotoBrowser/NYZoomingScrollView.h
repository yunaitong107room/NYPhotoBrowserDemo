//
//  NYZoomingScrollView.h
//  NYPhotoBrowserDemo
//
//  Created by Naitong Yu on 15/8/8.
//  Copyright (c) 2015年 107间. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYTappableImageView.h"
#import "NYPhotoBrowser.h"

@interface NYZoomingScrollView : UIScrollView

@property (nonatomic) NYTappableImageView *imageView;
@property (nonatomic) UIImage *image;

- (instancetype)initWithPhotoBrowser:(NYPhotoBrowser *)browser;

- (void)setMaxMinZoomScalesForCurrentBounds;

@end
