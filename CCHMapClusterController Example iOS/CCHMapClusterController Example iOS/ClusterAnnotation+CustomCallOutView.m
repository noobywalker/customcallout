//
//  ClusterAnnotation+CustomCallOutView.m
//  CCHMapClusterController Example iOS
//
//  Created by Waratnan Suriyasorn on 6/13/2558 BE.
//  Copyright (c) 2558 Claus Höfele. All rights reserved.
//

#import "ClusterAnnotation+CustomCallOutView.h"

#define CALLOUTVIEW_MARGIN 10
@interface ClusterAnnotationCustomCallOutView () {
        BOOL _hasCalloutView;
}


@property(nonatomic, strong) UIView *calloutView;
@property(nonatomic, strong) DXAnnotationSettings *settings;

@end
@implementation ClusterAnnotationCustomCallOutView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                       calloutView:(UIView *)calloutView
                          settings:(DXAnnotationSettings *)settings {
    

    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = NO;
        [self validateSettings:settings];
        _hasCalloutView = (calloutView) ? YES : NO;
        self.canShowCallout = NO;
        
        self.calloutView = calloutView;
        self.calloutView.hidden = YES;
        
        [self addSubview:self.calloutView];
//        self.frame = [self calculateFrame];
        if (_hasCalloutView) {
            if (self.settings.shouldAddCalloutBorder) {
                [self addCalloutBorder];
            }
            if (self.settings.shouldRoundifyCallout) {
                [self roundifyCallout];
            }
        }
        [self positionSubviews];
    }
    return self;
}

//- (CGRect)calculateFrame {
//    return self.image.bounds;
//}

- (void)positionSubviews {
    self.calloutView.center = self.center;
    if (_hasCalloutView) {
        CGRect frame = self.calloutView.frame;
        frame.origin.y = -frame.size.height - self.settings.calloutOffset;
        frame.origin.x = (self.frame.size.width - frame.size.width) / 2.0;
        self.calloutView.frame = frame;
    }
}

-(void)updateCallOutView {
    if (_hasCalloutView) {
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];

//        CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);


        CGPoint cPoint = self.calloutView.frame.origin;
        CGSize cSize =self.calloutView.frame.size;
        float callOutHalfSize = cSize.width/2;

        if(self.frame.origin.x - callOutHalfSize < 0) {

            cPoint.x = -self.frame.origin.x + CALLOUTVIEW_MARGIN ;
            self.calloutView.frame = CGRectMake(cPoint.x, cPoint.y, cSize.width, cSize.height);
    
        }else if(self.frame.origin.x + callOutHalfSize >screenBounds.size.width) {
            cPoint.x = -callOutHalfSize -(self.frame.origin.x + callOutHalfSize - screenBounds.size.width) - CALLOUTVIEW_MARGIN ;
            self.calloutView.frame = CGRectMake(cPoint.x, cPoint.y, cSize.width, cSize.height);

        }
    }

}
- (void)roundifyCallout {
    self.calloutView.layer.cornerRadius = self.settings.calloutCornerRadius;
}

- (void)addCalloutBorder {
    self.calloutView.layer.borderWidth = self.settings.calloutBorderWidth;
    self.calloutView.layer.borderColor = self.settings.calloutBorderColor.CGColor;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    if (_hasCalloutView) {
//        UITouch *touch = [touches anyObject];
//        // toggle visibility
//        if (touch.view == self.pinView) {
//            if (self.calloutView.isHidden) {
//                [self showCalloutView];
//            } else {
//                [self hideCalloutView];
//            }
//        } else if (touch.view == self.calloutView) {
//            [self showCalloutView];
//        } else {
//            [self hideCalloutView];
//        }
//    }
//}

- (void)hideCalloutView {
    if (_hasCalloutView) {
        if (!self.calloutView.isHidden) {
//            [self updateCallOutView];
            switch (self.settings.animationType) {
                case DXCalloutAnimationNone: {
                    self.calloutView.hidden = YES;
                } break;
                case DXCalloutAnimationZoomIn: {
                    self.calloutView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    [UIView animateWithDuration:self.settings.animationDuration animations:^{
                        self.calloutView.transform = CGAffineTransformMakeScale(0.25, 0.25);
                    } completion:^(BOOL finished) {
                        self.calloutView.hidden = YES;
                    }];
                } break;
                case DXCalloutAnimationFadeIn: {
                    self.calloutView.alpha = 1.0;
                    [UIView animateWithDuration:self.settings.animationDuration animations:^{
                        self.calloutView.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        self.calloutView.hidden = YES;
                    }];
                } break;
                default: {
                    self.calloutView.hidden = YES;
                } break;
            }
        }
    }
}

- (void)showCalloutView {
    
    NSLog(@"%f %f %f %f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);

    if (_hasCalloutView) {
        [self updateCallOutView];
        if (self.calloutView.isHidden) {
            switch (self.settings.animationType) {
                case DXCalloutAnimationNone: {
                    self.calloutView.hidden = NO;
                } break;
                case DXCalloutAnimationZoomIn: {
                    self.calloutView.transform = CGAffineTransformMakeScale(0.025, 0.25);
                    self.calloutView.hidden = NO;
                    [UIView animateWithDuration:self.settings.animationDuration animations:^{
                        self.calloutView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    } completion:nil];
                } break;
                case DXCalloutAnimationFadeIn: {
                    self.calloutView.alpha = 0.0;
                    self.calloutView.hidden = NO;
                    [UIView animateWithDuration:self.settings.animationDuration animations:^{
                        self.calloutView.alpha = 1.0;
                    } completion:nil];
                } break;
                default: {
                    self.calloutView.hidden = NO;
                } break;
            }
            
                    NSLog(@"%f %f %f %f",self.calloutView.frame.origin.x,self.calloutView.frame.origin.y,self.calloutView.frame.size.width,self.calloutView.frame.size.height);
        }
    }
}

#pragma mark - validate settings -

- (void)validateSettings:(DXAnnotationSettings *)settings {
    NSAssert(settings.calloutOffset >= 5.0, @"settings.calloutOffset should be atleast 5.0");
    if (settings.shouldRoundifyCallout) {
        NSAssert(settings.calloutCornerRadius >= 3.0, @"settings.calloutCornerRadius should be atleast 3.0");
    }
    
    if (settings.shouldAddCalloutBorder) {
        NSAssert(settings.calloutBorderColor != nil, @"settings.calloutBorderColor can not be nil");
        NSAssert(settings.calloutBorderWidth >= 1.0, @"settings.calloutBorderWidth should be atleast 1.0");
    }
    
    if (settings.animationType != DXCalloutAnimationNone) {
        NSAssert(settings.animationDuration > 0.0, @"settings.animationDuration should be greater than zero");
    }
    
    self.settings = settings;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
        return nil;
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isCallout = (CGRectContainsPoint(self.calloutView.frame, point));
    BOOL isPin = (CGRectContainsPoint(self.frame, point));
    return isCallout || isPin;
}


@end
