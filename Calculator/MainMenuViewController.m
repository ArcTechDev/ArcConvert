//
//  MainMenuViewController.m
//  Calculator
//
//  Created by User on 24/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController{
    
    //to store last translation on this view when panning
    CGPoint lastTranslation;
    
    //determine was panning left or right
    BOOL panLeft;
    
    //store previous controller's view in NavigationController
    //so we can use this view as bottom layer when panning
    //this view
    UIView *previousView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //register left edge pan
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgePanGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGesture];
     
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public  interface
- (void)addToParentViewController:(UIViewController *)parent{
    
    [super addToParentViewController:parent];
}

#pragma mark - Gesture
- (void)handleLeftEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture{
    
    //get current translation on this view
    CGPoint translation = [gesture translationInView:self.view.superview];
    
    //if it was panning left and translation x less equal to 0
    //edge pan left is positive value
    if(panLeft && translation.x <= 0.0){
        
        self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        return;
    }
    
    //check if pan left or right
    if(panLeft && translation.x > lastTranslation.x)
        panLeft = NO;
    else if(!panLeft && translation.x < lastTranslation.x)
        panLeft = YES;
    
    //when start pan gesture
    if(gesture.state == UIGestureRecognizerStateBegan){
        
        self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
        //if previousView is nil we need to find it
        if(previousView == nil){
            
            int previousViewControllerIndex = 0;
            
            //find the index of previousView in NavigationController
            for(int i=0; i<self.navigationController.viewControllers.count; i++){
                
                UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:i];
                
                if(controller == self){
                    
                    previousViewControllerIndex = i-1;
                    
                    break;
                }
            }
            
            //we add previousView to this view's super view and make it as bottom layer
            if(previousViewControllerIndex >= 0){
                
                previousView = ((UIViewController *)[self.navigationController.viewControllers objectAtIndex:previousViewControllerIndex]).view;
                
                [self.view.superview addSubview:previousView];
                [self.view.superview sendSubviewToBack:previousView];
            }
        }
        
        //store last translation
        lastTranslation = translation;
    }
    else if(gesture.state == UIGestureRecognizerStateChanged){//when pan gesture changed
        
        //calculate translation percent value  on view
        float percent = translation.x * 100.0 / self.view.frame.size.width / 100.0;
        
        self.view.frame = CGRectMake(self.view.frame.size.width * fabsf(percent), self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        
        lastTranslation = translation;
        
    }
    else{//somehow user's pan gesture end
        
        //start animation
        [UIView animateWithDuration:0.2 animations:^{
            
            //if was pan left animate view to left
            if(panLeft){
               
                self.view.frame = CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            }
            else{//otherwise animate view to right
                
                self.view.frame = CGRectMake(self.view.superview.frame.size.width + self.view.frame.size.width/2, self.view.frame.origin.y, self.view.frame.size.width , self.view.frame.size.height);
            }
        } completion:^(BOOL finished){
            
            if(finished){
                
                //if was pan left push controller to navigation controller
                if(!panLeft){
                    
                    if(previousView != nil){
                        
                        //we must remove previousView from its super view before pop this controller
                        [previousView removeFromSuperview];
                        previousView = nil;
                    }
                    
                    [self.navigationController popViewControllerAnimated:NO];
                }
                
            }
        }];
    }
    
}

- (void)onPushIntoNavigationController{

    //hide navigation bar
    self.navigationController.navigationBarHidden = YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
