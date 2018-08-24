//
//  DlibWrapper.h
//  BabyLikesWhatDlib
//
//  Created by Jonas Nockert on 2018-08-23.
//  Copyright © 2018 Jonas Nockert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@interface DlibWrapper : NSObject

- (instancetype) init;
- (NSArray<NSValue *> *) doWorkOnSampleBuffer:(CMSampleBufferRef)sampleBuffer inRects:(NSArray<NSValue *> *)rects;
- (void) prepare;

@end
