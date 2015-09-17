//
//  ViewController.m
//  Animation
//
//  Created by Jagtej Sodhi on 9/17/15.
//  Copyright © 2015 Jagtej Sodhi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *trayView;

@property (nonatomic, assign) CGPoint trayOriginalCenter;
@property (nonatomic, assign) CGPoint trayUpPosition;
@property (nonatomic, assign) CGPoint trayDownPosition;
@property (nonatomic, strong) UIImageView *newlyCreatedFace;
@property (nonatomic, assign) CGPoint trayOrigin;

@end

@implementation ViewController
int xVal = 40;
int yVal = 40;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.trayOriginalCenter = self.trayView.center;
    self.trayOrigin = self.trayView.frame.origin;
    self.trayUpPosition = self.trayView.center;
    self.trayDownPosition = CGPointMake(self.trayUpPosition.x, self.trayUpPosition.y + 130);
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTrayPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];

    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            //NSLog(@"Tray's original center: %f, %f", self.trayOriginalCenter.x, self.trayOriginalCenter.y);
            //NSLog(@"Gesture began at: %f, %f", point.x, point.y);
            break;
        case UIGestureRecognizerStateChanged:
            self.trayView.center = CGPointMake(self.trayOriginalCenter.x, self.trayOriginalCenter.y + [sender translationInView:self.trayView].y);
            //NSLog(@"Gesture changed at: %f, %f", point.x, point.y);
            break;
        case UIGestureRecognizerStateEnded: {
            CGPoint destination = CGPointMake(self.trayOriginalCenter.x, velocity.y > 0 ? self.trayDownPosition.y :
                                              self.trayUpPosition.y);
            
            [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0 options:0 animations:^{
                self.trayView.center = destination;
            } completion:^(BOOL finished) {
                //NSLog(@"Animation complete");
            }];
            
            //NSLog(@"Gesture ended at: %f, %f", point.x, point.y);
        }
            break;
        default:
            NSLog(@"Default");
    }
}

- (IBAction)smileyPanGesture:(UIPanGestureRecognizer *)sender {
    //NSLog(@"Smiley pan gesture");
    CGPoint point = [sender locationInView:self.view];
    
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            //release any old object
            self.newlyCreatedFace = nil;
            
            //get the image clicked
            UIImageView* imageView = (UIImageView* ) sender.view;
            
            self.newlyCreatedFace = [[UIImageView alloc] initWithImage:imageView.image];
            
            [self.view addSubview:self.newlyCreatedFace];
            
            self.newlyCreatedFace.center = CGPointMake(imageView.center.x, imageView.center.y + self.trayView.frame.origin.y);
        }
            break;
        case UIGestureRecognizerStateChanged:
            self.newlyCreatedFace.center = point;

            break;
        case UIGestureRecognizerStateEnded: {
            //if face is released in tray bounds, shoot to top open spot
            if (point.y > self.trayOrigin.y) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.newlyCreatedFace.center = CGPointMake(xVal, yVal);
                    xVal += 60;
                    
                    if (xVal == 340) {
                        xVal = 40;
                        yVal += 60;
                    }
                }];
            }
            
            self.newlyCreatedFace.userInteractionEnabled = YES;
            UIPanGestureRecognizer* newSmileyRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onNewSmileyPanGesture:)];
            [self.newlyCreatedFace addGestureRecognizer:newSmileyRecognizer];
        }
            break;
        default:
            NSLog(@"Default");
    }
    
}

- (void)onNewSmileyPanGesture: (UITapGestureRecognizer*)sender {
    CGRect newFrame = self.newlyCreatedFace.frame;
    
    newFrame.size.width = self.newlyCreatedFace.frame.size.width + 20;
    newFrame.size.height = self.newlyCreatedFace.frame.size.height + 20;
    
    CGPoint point = [sender locationInView:self.view];
    
    self.newlyCreatedFace.center = point;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            [self.newlyCreatedFace setFrame:newFrame];
            break;
        case UIGestureRecognizerStateChanged:
            self.newlyCreatedFace.center = point;
            break;
        case UIGestureRecognizerStateEnded:
            newFrame.size.width = self.newlyCreatedFace.frame.size.width - 20;
            newFrame.size.height = self.newlyCreatedFace.frame.size.height - 20;
            [self.newlyCreatedFace setFrame:newFrame];
            
            self.newlyCreatedFace.center = point;
            
            break;
        default:
            NSLog(@"Default");
    }
}


@end
