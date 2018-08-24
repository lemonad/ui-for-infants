//
//  DlibWrapper.m
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-23.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//


#include <dlib/opencv.h>
#include <dlib/image_processing.h>
#include <dlib/image_io.h>
#include <opencv2/opencv.hpp>
#import <UIKit/UIKit.h>
#include "Flags.h"
#import "KalmanPoint.h"
#import "KalmanRect.h"
#import "DlibWrapper.h"
#import "PupilDetector.h"


using std::vector;

@interface DlibWrapper ()

@property (assign) BOOL prepared;

+ (std::vector<dlib::rectangle>)convertCGRectValueArray:(NSArray<NSValue *> *)rects;

@end
@implementation DlibWrapper {
    dlib::shape_predictor sp;
    int noFaceDetectionCounter;
    KalmanRect *leftEyeKalman;
    KalmanRect *rightEyeKalman;
    KalmanRect *faceKalman;
    KalmanPoint *leftInnerEyeCornerKalman;
    KalmanPoint *leftOuterEyeCornerKalman;
    KalmanPoint *rightInnerEyeCornerKalman;
    KalmanPoint *rightOuterEyeCornerKalman;
    KalmanPoint *leftPupilKalman;
    KalmanPoint *rightPupilKalman;
}


- (instancetype)init {
    #ifdef SHOW_CAMERA_AND_LANDMARKS
    NSLog(@"Warning: Showing landmarks (slow) [SHOW_CAMERA_AND_LANDMARKS = 1 in flags.h].\n");
    #else
    NSLog(@"Warning: Optimized version: Not showing landmarks [SHOW_CAMERA_AND_LANDMARKS = 0 in flags.h].\n");
    #endif
    self = [super init];
    if (self) {
        _prepared = NO;
        noFaceDetectionCounter = 0;
    }
    return self;
}

- (void)prepare {
    NSString *modelFileName = [[NSBundle mainBundle] pathForResource:@"shape_predictor_5_face_landmarks" ofType:@"dat"];
    std::string modelFileNameCString = [modelFileName UTF8String];

    dlib::deserialize(modelFileNameCString) >> sp;

    cv::Mat pnc_eye_corners = (cv::Mat_<float>(4, 1) << 1, 1, 0.5, 0.5);
    cv::Mat mnc_eye_corners = (cv::Mat_<float>(2, 1) << 3, 3);
    cv::Mat pnc_pupils = (cv::Mat_<float>(4, 1) << 0.5, 0.5, 0.1, 0.1);
    cv::Mat mnc_pupils = (cv::Mat_<float>(2, 1) << 2, 2);

    leftInnerEyeCornerKalman = [[KalmanPoint alloc]
                                initWithProcessNoiseCov:(cv::Mat)pnc_eye_corners
                                measurementNoiseCov:(cv::Mat)mnc_eye_corners];
    leftOuterEyeCornerKalman = [[KalmanPoint alloc]
                                initWithProcessNoiseCov:(cv::Mat)pnc_eye_corners
                                measurementNoiseCov:(cv::Mat)mnc_eye_corners];
    rightInnerEyeCornerKalman = [[KalmanPoint alloc]
                                 initWithProcessNoiseCov:(cv::Mat)pnc_eye_corners
                                 measurementNoiseCov:(cv::Mat)mnc_eye_corners];
    rightOuterEyeCornerKalman = [[KalmanPoint alloc]
                                 initWithProcessNoiseCov:(cv::Mat)pnc_eye_corners
                                 measurementNoiseCov:(cv::Mat)mnc_eye_corners];
    leftPupilKalman = [[KalmanPoint alloc]
                       initWithProcessNoiseCov:(cv::Mat)pnc_pupils
                       measurementNoiseCov:(cv::Mat)mnc_pupils];
    rightPupilKalman = [[KalmanPoint alloc]
                        initWithProcessNoiseCov:(cv::Mat)pnc_pupils
                        measurementNoiseCov:(cv::Mat)mnc_pupils];

    // FIXME: test this stuff for memory leaks (cpp object destruction)
    self.prepared = YES;
}

- (void)saveImageU8:(cv::Mat)img filename:(NSString *)filename {
    dlib::array2d<unsigned char> img2d;
    dlib::assign_image(img2d, dlib::cv_image<unsigned char>(img));

    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    documentsPath = [documentsPath stringByAppendingPathComponent:filename];
    const char *savePath = [documentsPath UTF8String];
    save_jpeg(img2d, savePath);
}

- (NSArray<NSValue *> *) doWorkOnSampleBuffer:(CMSampleBufferRef)sampleBuffer
                                      inRects:(NSArray<NSValue *> *)rects {
    if (!self.prepared) {
        [self prepare];
    }

    // dlib::array2d<dlib::bgr_pixel> img;
    dlib::array2d<unsigned char> img;

    // MARK: magic
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);

    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    img.set_size(height, width);
    unsigned char *baseBuffer = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);

    // copy samplebuffer image data into dlib image format
    img.reset();
    long position = 0;
    while (img.move_next()) {
        unsigned char &pixel = img.element();
        pixel = baseBuffer[position];  // (row * width + column) * 3;
        ++position;
    }
//    // copy samplebuffer image data into dlib image format
//    img.reset();
//    long position = 0;
//    while (img.move_next()) {
//        dlib::bgr_pixel& pixel = img.element();
//
//        // assuming bgra format here
//        long bufferLocation = position * 4; //(row * width + column) * 4;
//        char b = baseBuffer[bufferLocation];
//        char g = baseBuffer[bufferLocation + 1];
//        char r = baseBuffer[bufferLocation + 2];
//        //        we do not need this
//        //        char a = baseBuffer[bufferLocation + 3];
//
//        dlib::bgr_pixel newpixel(b, g, r);
//        pixel = newpixel;
//
//        position++;
//    }

    // unlock buffer again until we need it again
    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);

    /* Kalman filter predictions */
    CGPoint left_pupil_offset, right_pupil_offset;
    cv::Point pt;
    pt = [leftPupilKalman predict];
    dlib::point left_pupil_pt(pt.x, pt.y);
    pt = [rightPupilKalman predict];
    dlib::point right_pupil_pt(pt.x, pt.y);
    pt = [leftInnerEyeCornerKalman predict];
    dlib::point left_inner_eye_corner_pt(pt.x, pt.y);
    pt = [leftOuterEyeCornerKalman predict];
    dlib::point left_outer_eye_corner_pt(pt.x, pt.y);
    pt = [rightInnerEyeCornerKalman predict];
    dlib::point right_inner_eye_corner_pt(pt.x, pt.y);
    pt = [rightOuterEyeCornerKalman predict];
    dlib::point right_outer_eye_corner_pt(pt.x, pt.y);
    left_pupil_offset = CGPointMake(left_pupil_pt.x() - left_inner_eye_corner_pt.x(),
                                    left_pupil_pt.y() - left_inner_eye_corner_pt.y());
    right_pupil_offset = CGPointMake(right_pupil_pt.x() - right_inner_eye_corner_pt.x(),
                                     right_pupil_pt.y() - right_inner_eye_corner_pt.y());

    // convert the face bounds list to dlib format
    std::vector<dlib::rectangle> convertedRectangles = [DlibWrapper convertCGRectValueArray:rects];

    /* Find largest face */
    unsigned long largestAreaIndex = 0;
    long largestArea = 0;

    for (unsigned long j = 0; j < convertedRectangles.size(); ++j) {
        dlib::rectangle oneFaceRect = convertedRectangles[j];
        long area = oneFaceRect.width() * oneFaceRect.height();
        if (area > largestArea) {
            largestAreaIndex = j;
            largestArea = area;
        }
    }

    dlib::rectangle oneFaceRect = convertedRectangles[largestAreaIndex];

    // detect all landmarks
    dlib::full_object_detection shape = sp(img, oneFaceRect);

    //        dlib::point p0 = shape.part(0);
    //        dlib::point p1 = shape.part(1);
    //        long xmin = MIN(p0.x(), p1.x());
    //        long xmax = MAX(p0.x(), p1.x());
    //        long ymin = MIN(p0.y(), p1.y());
    //        long ymax = MAX(p0.y(), p1.y());
    //        long xdist = xmax - xmin;
    //        dlib::rectangle r(p1.x() - 0.2 * xdist, ymin - 0.3 * xdist, xmax + 0.2 * xdist, ymax + 0.3 * xdist);
    //        draw_rectangle(img, r, dlib::rgb_pixel(0, 255, 255), 1);

    dlib::array2d<dlib::rgb_pixel> face_chip;
    dlib::rectangle shape_rect = shape.get_rect();

    // TODO adjust size to pupil detection algorithm?
    long sz = MAX(abs(shape_rect.left() - shape_rect.right()), abs(shape_rect.top() - shape_rect.bottom()));
    dlib::chip_details face_chip_details = dlib::get_face_chip_details(shape, sz, 0.0);
    dlib::extract_image_chip(img, face_chip_details, face_chip, dlib::interpolate_quadratic());
    dlib::full_object_detection chip_shape = dlib::map_det_to_chip(shape, face_chip_details);

    dlib::point_transform_affine transf = dlib::get_mapping_to_chip(face_chip_details);
    dlib::point_transform_affine inv_transf = dlib::inv(transf);

    //        for (long r = 0; r < face_chip.nr(); ++r) {
    //            for (long c = 0; c < face_chip.nc(); ++c) {
    //                dlib::assign_pixel(img[r][c], face_chip[r][c]);
    //            }
    //        }

    // The 5 point face annotation scheme is assumed to be:
    // - det part 0 == left eye corner, outside part of eye.
    // - det part 1 == left eye corner, inside part of eye.
    // - det part 2 == right eye corner, outside part of eye.
    // - det part 3 == right eye corner, inside part of eye.
    // - det part 4 == immediately under the nose, right at the top of the philtrum.
    dlib::point p0 = chip_shape.part(0);
    dlib::point p1 = chip_shape.part(1);
    dlib::point p2 = chip_shape.part(2);
    dlib::point p3 = chip_shape.part(3);

    [leftInnerEyeCornerKalman correct:cv::Point(int(p1.x()), int(p1.y()))];
    [leftOuterEyeCornerKalman correct:cv::Point(int(p0.x()), int(p0.y()))];
    [rightInnerEyeCornerKalman correct:cv::Point(int(p3.x()), int(p3.y()))];
    [rightOuterEyeCornerKalman correct:cv::Point(int(p2.x()), int(p2.y()))];

    long ymin = MIN(p0.y(), p1.y());
    long ymax = MAX(p0.y(), p1.y());
    long xdist = p0.x() - p1.x();
    // dlib::rectangle r2(p1.x(), ymin - 0.4 * xdist, p0.x(), ymax + 0.3 * xdist);
    dlib::rectangle r2(p1.x() - xdist * 0.25, ymin - 0.4 * xdist, p0.x() + xdist * 0.25, ymax + 0.3 * xdist);

    ymin = MIN(p2.y(), p3.y());
    ymax = MAX(p2.y(), p3.y());
    xdist = p3.x() - p2.x();
    // dlib::rectangle r3(p2.x(), ymin - 0.4 * xdist, p3.x(), ymax + 0.3 * xdist);
    dlib::rectangle r3(p2.x() - xdist * 0.25, ymin - 0.4 * xdist, p3.x() + xdist * 0.25, ymax + 0.3 * xdist);

    auto simg = dlib::sub_image(face_chip, r2);
    dlib::array2d<unsigned char> img_gray;
    dlib::assign_image(img_gray, simg);
    cv::Mat left_eye = dlib::toMat(img_gray);

    // cv::Point pupil = findEyeCenter(right_eye);
    cv::Mat eye_mask_eroded, eye_subregion_mask;
    cv::Point pupil = [PupilDetector cdfDetection:left_eye out1:eye_mask_eroded];
    [leftPupilKalman correct:pupil];
    // cv::Point pupil = findCenterOfPupilCDFDetection(right_eye, eye_mask_eroded, eye_subregion_mask);
    [self saveImageU8:left_eye filename:@"left_eye.jpg"];
    // [self saveImageU8:eye_mask_eroded filename:@"right_eye_mask_eroded.jpg"];
    // [self saveImageU8:eye_subregion_mask filename:@"right_eye_subregion_mask.jpg"];

    // printf("before (left): %f\n", left_pupil_offset.x);
    // left_pupil_offset = CGPointMake(pupil.x - p0.x(), pupil.y - p0.y());
    //printf("after (left): %f\n", left_pupil_offset.x);
    // CGPoint right_pupil_offset = CGPointMake(pupil.x - p0.x(), pupil.y - p0.y());

    dlib::point pp(r2.left() + pupil.x, r2.top() + pupil.y);

    simg = dlib::sub_image(face_chip, r3);
    dlib::assign_image(img_gray, simg);
    cv::Mat right_eye = dlib::toMat(img_gray);
    pupil = [PupilDetector cdfDetection:right_eye out1:eye_mask_eroded];
    [rightPupilKalman correct:pupil];
    // pupil = findCenterOfPupilCDFDetection(left_eye, eye_mask_eroded, eye_subregion_mask);
    [self saveImageU8:right_eye filename:@"right_eye.jpg"];
    // [self saveImageU8:eye_mask_eroded filename:@"left_eye_mask_eroded.jpg"];
    // [self saveImageU8:eye_subregion_mask filename:@"left_eye_subregion_mask.jpg"];

    // right_pupil_offset = CGPointMake(pupil.x - p3.x(), pupil.y - p3.y());
    // CGPoint left_pupil_offset = CGPointMake(pupil.x - p3.x(), pupil.y - p3.y());

    // return @[[NSValue valueWithCGPoint: left_pupil_offset], [NSValue valueWithCGPoint: right_pupil_offset]];

    #ifdef SHOW_CAMERA_AND_LANDMARKS
    dlib::point pp2(r3.left() + pupil.x, r3.top() + pupil.y);

    unsigned char bw = 255;
    unsigned char bwinv = 255 - bw;

    int radius = 6;
    /* Pupils in box */
    draw_rectangle(img, r2, bw, 3);
    draw_rectangle(img, r3, bw, 3);
//    draw_solid_circle(img, pp, radius, bw);
//    draw_solid_circle(img, pp2, radius, bw);
//    draw_solid_circle(img, pp, radius - 2, bwinv);
//    draw_solid_circle(img, pp2, radius - 2, bwinv);

    /* Pupils in face*/
    draw_solid_circle(img, left_pupil_pt, radius, bw);
    draw_solid_circle(img, left_pupil_pt, radius - 2, bwinv);
    draw_solid_circle(img, right_pupil_pt, radius, bw);
    draw_solid_circle(img, right_pupil_pt, radius - 2, bwinv);

    draw_solid_circle(img, left_inner_eye_corner_pt, radius, bw);
    draw_solid_circle(img, left_inner_eye_corner_pt, radius - 2, bwinv);
    draw_solid_circle(img, right_inner_eye_corner_pt, radius, bw);
    draw_solid_circle(img, right_inner_eye_corner_pt, radius - 2, bwinv);

    draw_solid_circle(img, left_outer_eye_corner_pt, radius, bw);
    draw_solid_circle(img, left_outer_eye_corner_pt, radius - 2, bwinv);
    draw_solid_circle(img, right_outer_eye_corner_pt, radius, bw);
    draw_solid_circle(img, right_outer_eye_corner_pt, radius - 2, bwinv);

//    // and draw them into the image (samplebuffer)
//    for (unsigned long k = 0; k < shape.num_parts(); k++) {
//        dlib::point p = shape.part(k);
//        draw_solid_circle(img, p, radius, bw);
//        draw_solid_circle(img, p, radius - 2, bwinv);
//    }

//    /* Pupils in face*/
//    dlib::point ipp = inv_transf(pp);
//    dlib::point ipp2 = inv_transf(pp2);
//    draw_solid_circle(img, ipp, radius, bw);
//    draw_solid_circle(img, ipp2, radius, bw);
//    draw_solid_circle(img, ipp, radius - 2, bwinv);
//    draw_solid_circle(img, ipp2, radius - 2, bwinv);
//
//    // and draw them into the image (samplebuffer)
//    for (unsigned long k = 0; k < shape.num_parts(); k++) {
//        dlib::point p = shape.part(k);
//        draw_solid_circle(img, p, radius, bw);
//        draw_solid_circle(img, p, radius - 2, bwinv);
//    }

    // lets put everything back where it belongs
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    baseBuffer = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);

    // copy dlib image data back into samplebuffer
    img.reset();
    position = 0;
    while (img.move_next()) {
        long loc = position;
        baseBuffer[loc] = img.element();  // (row * width + column) * 3;
        ++position;
    }

//    // copy dlib image data back into samplebuffer
//    img.reset();
//    position = 0;
//    while (img.move_next()) {
//        dlib::bgr_pixel& pixel = img.element();
//
//        // assuming bgra format here
//        long bufferLocation = position * 4; //(row * width + column) * 4;
//        baseBuffer[bufferLocation] = pixel.blue;
//        baseBuffer[bufferLocation + 1] = pixel.green;
//        baseBuffer[bufferLocation + 2] = pixel.red;
//        //        we do not need this
//        //        char a = baseBuffer[bufferLocation + 3];
//
//        position++;
//    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    #endif

    return @[[NSValue valueWithCGPoint: left_pupil_offset], [NSValue valueWithCGPoint: right_pupil_offset]];
}

+ (std::vector<dlib::rectangle>)convertCGRectValueArray:(NSArray<NSValue *> *)rects {
    std::vector<dlib::rectangle> myConvertedRects;
    for (NSValue *rectValue in rects) {
        CGRect rect = [rectValue CGRectValue];
        long left = rect.origin.x;
        long top = rect.origin.y;
        long right = left + rect.size.width;
        long bottom = top + rect.size.height;
        dlib::rectangle dlibRect(left, top, right, bottom);

        myConvertedRects.push_back(dlibRect);
    }
    return myConvertedRects;
}

@end
