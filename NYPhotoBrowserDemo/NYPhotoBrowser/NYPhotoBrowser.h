//
//  NYPhotoBrowser.h
//  NYPhotoBrowserDemo
//
//  Created by Naitong Yu on 15/8/8.
//  Copyright (c) 2015年 107间. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delegate
@class NYPhotoBrowser;
@protocol NYPhotoBrowserDelegate <NSObject>
@optional
// 该代理方法中的index会随着imageArray中元素的删除而变化
- (void)photoBrowser:(NYPhotoBrowser *)browser DidDeletePhotoAtIndex:(NSUInteger)index;
@end

@interface NYPhotoBrowser : UIViewController

// properties
@property (nonatomic, weak) id <NYPhotoBrowserDelegate> delegate;

// animation time (default .28)
@property (nonatomic) float animationDuration;

// Init
- (instancetype)initWithImages:(NSArray *)images;

// Set page that photo browser starts on
- (void)setInitialPageIndex:(NSUInteger)index;

// Get image at index
- (UIImage *)imageAtIndex:(NSUInteger)index;

@end
