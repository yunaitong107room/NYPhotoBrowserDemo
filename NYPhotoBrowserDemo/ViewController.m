//
//  ViewController.m
//  NYPhotoBrowserDemo
//
//  Created by Naitong Yu on 15/8/8.
//  Copyright (c) 2015年 107间. All rights reserved.
//

#import "ViewController.h"
#import "NYPhotoBrowser.h"

@interface ViewController () <NYPhotoBrowserDelegate>

@property (nonatomic) NSMutableArray *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 4; i++) {
        NSString *imgName = [NSString stringWithFormat:@"photo%dl", i];
        UIImage *image = [UIImage imageNamed:imgName];
        [self.imageArray addObject:image];
    }
    
    
}

- (IBAction)showImage:(UIButton *)sender {
    NYPhotoBrowser *browser = [[NYPhotoBrowser alloc] initWithImages:self.imageArray];
    browser.delegate = self;
    [self presentViewController:browser animated:YES completion:nil];
}

- (void)photoBrowser:(NYPhotoBrowser *)browser DidDeletePhotoAtIndex:(NSUInteger)index {
    NSLog(@"delete %lu", (unsigned long) index);
}

@end
