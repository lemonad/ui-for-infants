//
//  KalmanRect.mm
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-16.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

#import <opencv2/core.hpp>
#import "KalmanRect.h"

#define HISTORY_SIZE 9
#define STATE_SIZE 6
#define MEASURE_SIZE 4
#define CONTROL_SIZE 0
#define CV_TYPE CV_32F
#define CPP_TYPE float

@implementation KalmanRect {
    NSDate *last_date;
    bool found;
    cv::KalmanFilter kf;
    cv::Mat state;
    cv::Mat meas;
}

- (id) init {
    cv::Mat pnc = (cv::Mat_<CPP_TYPE>(6, 1) << 1e-1, 1e-1, 1e-1, 1e-1, 1e-1, 1e-1);
    cv::Mat mnc = (cv::Mat_<CPP_TYPE>(4, 1) << 1e-1, 1e-1, 1e-1, 1e-1);
    self = [self initWithProcessNoiseCov:pnc measurementNoiseCov:mnc];
    return self;
}

- (instancetype) initWithProcessNoiseCov:(cv::Mat)pnc measurementNoiseCov:(cv::Mat)mnc {
    self = [super init];
    if (self) {
        kf = cv::KalmanFilter(STATE_SIZE, MEASURE_SIZE, CONTROL_SIZE, CV_TYPE);
        state = cv::Mat(STATE_SIZE, 1, CV_TYPE);   // [x, y, vx, vy, w, h]
        meas = cv::Mat (MEASURE_SIZE, 1, CV_TYPE);  // [zx, zy, zw, zh]

        /* State transition matrix (A).
         Used for calculating (and updating) the estimated, or next, state of the
         parameters. It is updated with dt in the predict phase which results in the
         following transitions:

         position_i (x, y) = position_{i-1} + dt_i * velocity_{i-1}
         velocity_i (vx, vy) = velocity_{i-1}
         dimensions_i (w, h) = dimensions_{i-1},

         In matrix form:

         [ 1  0  dt 0  0  0 ]
         [ 0  1  0  dt 0  0 ]
         [ 0  0  1  0  0  0 ]
         [ 0  0  0  1  0  0 ]
         [ 0  0  0  0  1  0 ]
         [ 0  0  0  0  0  1 ]
         */
        cv::setIdentity(kf.transitionMatrix);

        // Face detections results in four sensor measurements,
        // position (x, y) and dimension (w, h). I.e.
        //   [ 1 0 0 0 0 0 ]
        //   [ 0 1 0 0 0 0 ]
        //   [ 0 0 0 0 1 0 ]
        //   [ 0 0 0 0 0 1 ]
        kf.measurementMatrix = cv::Mat::zeros(MEASURE_SIZE, STATE_SIZE, CV_TYPE);
        kf.measurementMatrix.at<CPP_TYPE>(0) = 1.0f;
        kf.measurementMatrix.at<CPP_TYPE>(7) = 1.0f;
        kf.measurementMatrix.at<CPP_TYPE>(16) = 1.0f;
        kf.measurementMatrix.at<CPP_TYPE>(23) = 1.0f;

        // Process Noise Covariance Matrix (Q):
        //   [ Ex  0   0   0   0   0  ]
        //   [ 0   Ey  0   0   0   0  ]
        //   [ 0   0   Evx 0   0   0  ]
        //   [ 0   0   0   Evy 0   0  ]
        //   [ 0   0   0   0   Ew  0  ]
        //   [ 0   0   0   0   0   Eh ]
        kf.processNoiseCov.at<CPP_TYPE>(0) = pnc.at<CPP_TYPE>(0);
        kf.processNoiseCov.at<CPP_TYPE>(7) = pnc.at<CPP_TYPE>(1);
        kf.processNoiseCov.at<CPP_TYPE>(14) = pnc.at<CPP_TYPE>(2);
        kf.processNoiseCov.at<CPP_TYPE>(21) = pnc.at<CPP_TYPE>(3);
        kf.processNoiseCov.at<CPP_TYPE>(28) = pnc.at<CPP_TYPE>(4);
        kf.processNoiseCov.at<CPP_TYPE>(35) = pnc.at<CPP_TYPE>(5);

        // Measurement Noise Covariance Matrix (R).
        //   [ Ex 0  0  0 ]
        //   [ 0  Ey 0  0 ]
        //   [ 0  0  Ew 0 ]
        //   [ 0  0  0  Eh ]
        // Since we are using pixels,
        kf.measurementNoiseCov.at<CPP_TYPE>(0) = mnc.at<CPP_TYPE>(0);
        kf.measurementNoiseCov.at<CPP_TYPE>(5) = mnc.at<CPP_TYPE>(1);
        kf.measurementNoiseCov.at<CPP_TYPE>(10) = mnc.at<CPP_TYPE>(2);
        kf.measurementNoiseCov.at<CPP_TYPE>(15) = mnc.at<CPP_TYPE>(3);

        last_date = [[NSDate alloc] init];
        found = false;
    }
    return self;
}

- (cv::Rect) predict {
    cv::Rect predRect;

    // Have previous detections?
    if (found) {
        NSDate * date = [[NSDate alloc] init];
        NSTimeInterval dt = [date timeIntervalSinceDate:last_date];
        last_date = date;

        kf.transitionMatrix.at<CPP_TYPE>(2) = dt;
        kf.transitionMatrix.at<CPP_TYPE>(9) = dt;

        state = kf.predict();

        predRect.width = state.at<CPP_TYPE>(4);
        predRect.height = state.at<CPP_TYPE>(5);
        predRect.x = state.at<CPP_TYPE>(0) - predRect.width / 2;
        predRect.y = state.at<CPP_TYPE>(1) - predRect.height / 2;
    }
    return predRect;
}

- (void) restart {
    found = false;
}

- (void) correct:(cv::Rect)r {
    meas.at<CPP_TYPE>(0) = r.x + r.width / 2;
    meas.at<CPP_TYPE>(1) = r.y + r.height / 2;
    meas.at<CPP_TYPE>(2) = r.width;
    meas.at<CPP_TYPE>(3) = r.height;

    if (found) {
        kf.correct(meas);
    } else {
        kf.errorCovPre.at<CPP_TYPE>(0) = 1;
        kf.errorCovPre.at<CPP_TYPE>(7) = 1;
        kf.errorCovPre.at<CPP_TYPE>(14) = 1;
        kf.errorCovPre.at<CPP_TYPE>(21) = 1;
        kf.errorCovPre.at<CPP_TYPE>(28) = 1;
        kf.errorCovPre.at<CPP_TYPE>(35) = 1;

        state.at<CPP_TYPE>(0) = meas.at<CPP_TYPE>(0);
        state.at<CPP_TYPE>(1) = meas.at<CPP_TYPE>(1);
        state.at<CPP_TYPE>(2) = 0;
        state.at<CPP_TYPE>(3) = 0;
        state.at<CPP_TYPE>(4) = meas.at<CPP_TYPE>(2);
        state.at<CPP_TYPE>(5) = meas.at<CPP_TYPE>(3);

        kf.statePost = state;
        found = true;
    }
}

@end
