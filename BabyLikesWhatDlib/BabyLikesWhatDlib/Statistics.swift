//
//  Statistics.swift
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-23.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

import Foundation


/*
 Pearson's Product Moment Correlation Coefficient.

 Pearson's $r$ summarizes the relationship between two
 variables that have a straight line or linear relationship
 with each other.

 If the two variables have a straight line relationship in
 the positive direction, then $r$ will be positive and
 considerably above $0$.

 If the linear relationship is in the negative direction, so
 that increases in one variable, are associated with decreases
 in the other, then $r < 0$.

 The possible values of $r$ range from $-1$ to $+1$, with
 values close to $0$ signifying little relationship between
 the two variables.

 $r = E((X_i - \mu_X)(Y_i - \mu_Y)) / (\sigma_X \sigma_Y)$,

 where $\sigma_X = \sqrt{\sum (X_i - \mu_X)^2}$.

 */
func CorrelationCoefficient(X: [Double], Y: [Double]) -> Double {
    // Calculate variances of X and Y (standard deviation squared).
    return Covariance(X: X, Y: Y) / sqrt(Variance(X) * Variance(Y))
}

func Covariance(X: [Double], Y: [Double]) -> Double {
    guard X.count == Y.count else {
        // Has to be same size
        print("Error: X and Y not of same size when calculating covariance (",
              X.count, " vs ", Y.count, ".")
        return 0.0
    }

    let meanX = Mean(X)
    let meanY = Mean(Y)

    // Calculate variances of X and Y (standard deviation squared).
    var covarianceXY = 0.0
    for index in 0..<X.count {
        let xm = X[index] - meanX
        let ym = Y[index] - meanY
        covarianceXY += xm * ym
    }
    return covarianceXY
}

func Mean(_ X: [Double]) -> Double {
    let len = X.count
    var sumX = 0.0

    // Calculate mean.
    for index in 0..<len {
        sumX += X[index]
    }

    return sumX / Double(len)
}

func Variance(_ X: [Double]) -> Double {
    let meanX = Mean(X)

    var varianceX = 0.0  // Square

    for index in 0..<X.count {
        let xm = X[index] - meanX
        varianceX += xm * xm
    }
    return varianceX
}

func StdDev(_ X: [Double]) -> Double {
    return sqrt(Variance(X))
}
