//
//  ClusterAnnotation+CustomCallOutView.h
//  CCHMapClusterController Example iOS
//
//  Created by Waratnan Suriyasorn on 6/13/2558 BE.
//  Copyright (c) 2558 Claus Höfele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClusterAnnotationView.h"
#import "DXAnnotationSettings.h"

@interface ClusterAnnotationCustomCallOutView : ClusterAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                       calloutView:(UIView *)calloutView
                          settings:(DXAnnotationSettings *)settings;

- (void)hideCalloutView;
- (void)showCalloutView;

@end
