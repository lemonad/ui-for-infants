//
//  KalmanRect.h
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-16.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>

@interface KalmanRect : NSObject

- (instancetype) init;
- (instancetype) initWithProcessNoiseCov:(cv::Mat)pnc measurementNoiseCov:(cv::Mat)mnc;
- (cv::Rect) predict;
- (void) restart;
- (void) correct:(cv::Rect)r;

@end
