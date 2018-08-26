//
//  PupilDetector.mm
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-11.
//  Copyright © 2018 ZweiGraf. All rights reserved.
//

#import <opencv2/core.hpp>
#import "PupilDetector.h"

@implementation PupilDetector

+ (cv::Point) cdfDetection:(cv::Mat)eye_image out1:(cv::Mat &)out1 out2:(cv::Mat &)out2 out3:(cv::Mat &)out3 out4:(cv::Mat &)out4 {
    cv::Mat hist;

    const int kernel_size = 2;
    const int small_window = 15;
    const int large_window = 23;

    int channels[] = {0};
    int histSize[] = {256};
    float hranges[] = { 0, 256 };  // { 0, 255 }?
    const float* ranges[] = { hranges };

    cv::calcHist(&eye_image, 1, channels, cv::noArray(), hist, 1, histSize, ranges);
    float cdf[256] = {0};
    float tot = 0;
    for (int r = 0; r < 256; ++r) {
        tot += hist.at<float>(r);
    }
    // TODO Handle edge case where tot is zero.
    float s = 0;
    for (int r = 0; r < 256; ++r) {
        hist.at<float>(r) /= tot;
        s += hist.at<float>(r);
        cdf[r] = s;
    }

    cv::Mat eye_mask(eye_image.rows, eye_image.cols, CV_8U);
    for (int r = 0; r < eye_image.rows; ++r) {
        for (int c = 0; c < eye_image.cols; ++c) {
            auto v = eye_image.at<unsigned char>(r, c);
            if (cdf[v] <= 0.05) {
                eye_mask.at<unsigned char>(r, c) = 255;
            } else {
                eye_mask.at<unsigned char>(r, c) = 0;
            }
        }
    }

    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, cv::Size(kernel_size, kernel_size));
    cv::Mat eye_mask_eroded;
    cv::erode(eye_mask, eye_mask_eroded, kernel);

    double minVal;
    cv::Point minLoc;
    cv::minMaxLoc(eye_image, &minVal, NULL, &minLoc, NULL, eye_mask_eroded);
    // std::cout << "minVal: " << minVal << std::endl;

    // image_color = cv2.circle(image_color, maxLoc, 5, (0, 0, 255))
    float minloc_x1 = fmax(minLoc.x - small_window, 0);
    float minloc_y1 = fmax(minLoc.y - small_window, 0);
    float minloc_x2 = fmin(minLoc.x + small_window + 1, eye_image.cols);
    float minloc_y2 = fmin(minLoc.y + small_window + 1, eye_image.rows);
    cv::Rect small_subregion(minloc_x1, minloc_y1, minloc_x2 - minloc_x1, minloc_y2 - minloc_y1);
    minloc_x1 = fmax(minLoc.x - large_window, 0);
    minloc_y1 = fmax(minLoc.y - large_window, 0);
    minloc_x2 = fmin(minLoc.x + large_window + 1, eye_image.cols);
    minloc_y2 = fmin(minLoc.y + large_window + 1, eye_image.rows);
    cv::Rect large_subregion(minloc_x1, minloc_y1, minloc_x2 - minloc_x1, minloc_y2 - minloc_y1);

    // std::cout << "MinLoc: " << minLoc.x << ", " << minLoc.y << std::endl;
    cv::Scalar_<float> avg_intensity = cv::mean(eye_image(small_subregion));
    // std::cout << "Average intensity: " << avg_intensity << std::endl;
    cv::Mat eye_subregion;
    cv::erode(eye_image(large_subregion), eye_subregion, kernel, cv::Point(-1, -1),
              1, cv::BORDER_CONSTANT, cv::Scalar(0));

    cv::Mat eye_subregion_mask = (eye_subregion <= avg_intensity[0]);
    float cog_x = 0, cog_y = 0, total = 0;
    for (int r = 0; r < eye_subregion_mask.rows; ++r) {
        for (int c = 0; c < eye_subregion_mask.cols; ++c) {
            float v = eye_subregion_mask.at<unsigned char>(r, c);
            cog_x = cog_x + c * v;
            cog_y = cog_y + r * v;
            total = total + v;
        }
    }

    // TODO Check for total being zero
    // std::cout << "cog before norm: " << cog_x << ", " << cog_y << std::endl;
    cog_x = int(cog_x / total);
    cog_y = int(cog_y / total);
    // std::cout << "cog after norm: " << cog_x << ", " << cog_y << std::endl;
    cog_x = minloc_x1 + cog_x;
    cog_y = minloc_y1 + cog_y;
    // std::cout << "Center of Gravity: " << cog_x << ", " << cog_y << std::endl;

#if 0
    eye_mask_eroded.copyTo(out1);
    eye_subregion.copyTo(out2);
    eye_subregion_mask.copyTo(out3);
    cvtColor(eye_subregion, out4, CV_GRAY2BGR);
    cv::circle(out4, cv::Point(cog_x, cog_y), 5, cv::Scalar(255, 0, 0));
    cv::rectangle(out4, large_subregion, cv::Scalar(255, 0, 0));
#endif

    return cv::Point(cog_x, cog_y);
}

@end
