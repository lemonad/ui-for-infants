//
//  OpenCVWrapper.m
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-23.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

#import "OpenCVWrapper.h"
// #import "UIImage+OpenCV.h"
// #import "Eyes.hpp"


@implementation OpenCVWrapper

+ (CGPoint)getPupilPoint:(UIImage*)eyeFrame
{
    cv::Mat frame;
    cv::Rect eyeRegion(0, 0, eyeFrame.size.width, eyeFrame.size.height);

    UIImageToMat(eyeFrame, frame, true);
    // cv::Point pupil = findEyeCenter(frame, eyeRegion, "");
    // cv::Point pupil = findEyeCenter(frame);
    cv::Point pupil;

    CGPoint point = CGPointMake(pupil.x, pupil.y);
    return point;
}

@end
