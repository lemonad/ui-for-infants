//
//  KalmanPoint.mm
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-20.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

#import <opencv2/core.hpp>
#import "KalmanPoint.h"

#define HISTORY_SIZE 9
#define STATE_SIZE 4
#define MEASURE_SIZE 2
#define CONTROL_SIZE 0
#define CV_TYPE CV_32F
#define CPP_TYPE float

@implementation KalmanPoint {
    NSDate *last_date;
    bool found;
    cv::KalmanFilter kf;
    cv::Mat state;
    cv::Mat meas;
}

- (id) init {
    cv::Mat pnc = (cv::Mat_<CPP_TYPE>(4, 1) << 1e-1, 1e-1, 1e-1, 1e-1);
    cv::Mat mnc = (cv::Mat_<CPP_TYPE>(2, 1) << 1e-1, 1e-1);
    self = [self initWithProcessNoiseCov:pnc measurementNoiseCov:mnc];
    return self;
}

- (instancetype) initWithProcessNoiseCov:(cv::Mat)pnc measurementNoiseCov:(cv::Mat)mnc {
    self = [super init];
    if (self) {
        kf = cv::KalmanFilter(STATE_SIZE, MEASURE_SIZE, CONTROL_SIZE, CV_TYPE);
        state = cv::Mat(STATE_SIZE, 1, CV_TYPE);   // [x, y, vx, vy]
        meas = cv::Mat (MEASURE_SIZE, 1, CV_TYPE);  // [zx, zy]

        /* State transition matrix (A).
         Used for calculating (and updating) the estimated, or next, state of the
         parameters. It is updated with dt in the predict phase which results in the
         following transitions:

         position_i (x, y) = position_{i-1} + dt_i * velocity_{i-1}
         velocity_i (vx, vy) = velocity_{i-1}

         In matrix form:

         [ 1  0  dt 0  ]
         [ 0  1  0  dt ]
         [ 0  0  1  0  ]
         [ 0  0  0  1  ]
         */
        cv::setIdentity(kf.transitionMatrix);

        // Face detections results in two sensor measurements, position (x, y). I.e.
        //   [ 1 0 0 0 ]
        //   [ 0 1 0 0 ]
        //   [ 0 0 0 0 ]
        //   [ 0 0 0 0 ]
        kf.measurementMatrix = cv::Mat::zeros(MEASURE_SIZE, STATE_SIZE, CV_TYPE);
        kf.measurementMatrix.at<CPP_TYPE>(0) = 1.0f;
        kf.measurementMatrix.at<CPP_TYPE>(5) = 1.0f;

        // Process Noise Covariance Matrix (Q):
        //   [ Ex  0   0   0   ]
        //   [ 0   Ey  0   0   ]
        //   [ 0   0   Evx 0   ]
        //   [ 0   0   0   Evy ]
        kf.processNoiseCov.at<CPP_TYPE>(0) = pnc.at<CPP_TYPE>(0);
        kf.processNoiseCov.at<CPP_TYPE>(5) = pnc.at<CPP_TYPE>(1);
        kf.processNoiseCov.at<CPP_TYPE>(10) = pnc.at<CPP_TYPE>(2);
        kf.processNoiseCov.at<CPP_TYPE>(15) = pnc.at<CPP_TYPE>(3);

        // Measurement Noise Covariance Matrix (R).
        //   [ Ex 0  ]
        //   [ 0  Ey ]
        // Since we are using pixels, magnitudes will be around one.
        kf.measurementNoiseCov.at<CPP_TYPE>(0) = mnc.at<CPP_TYPE>(0);
        kf.measurementNoiseCov.at<CPP_TYPE>(3) = mnc.at<CPP_TYPE>(1);

        last_date = [[NSDate alloc] init];
        found = false;
    }
    return self;
}

- (cv::Point) predict {
    cv::Point predPoint;

    // Have previous detections?
    if (found) {
        NSDate * date = [[NSDate alloc] init];
        NSTimeInterval dt = [date timeIntervalSinceDate:last_date];
        last_date = date;

        kf.transitionMatrix.at<CPP_TYPE>(2) = dt;
        kf.transitionMatrix.at<CPP_TYPE>(7) = dt;

        state = kf.predict();

        predPoint.x = state.at<CPP_TYPE>(0);
        predPoint.y = state.at<CPP_TYPE>(1);
    }
    return predPoint;
}

- (void) restart {
    found = false;
}

- (void) correct:(cv::Point)p {
    meas.at<CPP_TYPE>(0) = p.x;
    meas.at<CPP_TYPE>(1) = p.y;

    if (found) {
        kf.correct(meas);
    } else {
        kf.errorCovPre.at<CPP_TYPE>(0) = 1;
        kf.errorCovPre.at<CPP_TYPE>(5) = 1;
        kf.errorCovPre.at<CPP_TYPE>(10) = 1;
        kf.errorCovPre.at<CPP_TYPE>(15) = 1;

        state.at<CPP_TYPE>(0) = meas.at<CPP_TYPE>(0);
        state.at<CPP_TYPE>(1) = meas.at<CPP_TYPE>(1);
        state.at<CPP_TYPE>(2) = 0;
        state.at<CPP_TYPE>(3) = 0;

        kf.statePost = state;
        found = true;
    }
}

@end
