//
//  SlideViewController.m
//  Calculator
//
//  Created by User on 18/8/15.
//  Copyright (c) 2015 ArcTech. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuItemCell.h"

@implementation MenuItem

@synthesize itemTitle = _itemTitle;

+ (id)createMenuItem:(NSString *)title{

    MenuItem *item = [[MenuItem alloc] init];
    
    item.itemTitle = title;
    
    return item;
}

@end

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController{
    
    //store menu item data
    NSMutableArray *menuItems;
    
    //current menu moving direction
    enum MenuDirectoin currentDirection;
    
    //user last touch translation on view
    CGPoint lastTranslation;
    
    //menu's max center on x axis
    float maxCenterX;
    
    //menu's min center on x axis
    float minCenterX;
    
    //determine if menu view is slide in or not
    BOOL isSlideIn;
}

@synthesize maxViewToShowMultiplier = _maxViewToShowMultiplier;
@synthesize acceleration = _acceleration;
@synthesize direction = _direction;
@synthesize lastTouchTranslation = _lastTouchTranslation;
@synthesize delegate = _delegate;

#pragma mark- Getter
/**
 * Getter for menu direction
 */
- (enum MenuDirectoin)getDirection{
    
    return currentDirection;
}

#pragma mark - Setter
/**
 * Setter for menu last touch translation
 */
- (void)setLastTouchTranslation:(CGPoint)lastTouchTranslation{
    
    lastTranslation = lastTouchTranslation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set acceleration
    _acceleration = 0.5;
    
    //set how much of menu view to show
    _maxViewToShowMultiplier = 0.5;
    
    //set current menu direction to none
    currentDirection = None;
    
    //set last touch translation
    lastTranslation = CGPointZero;
    
    //calcluate max menu center x to reach
    maxCenterX = self.view.frame.size.width * _maxViewToShowMultiplier - self.view.frame.size.width / 2;
    
    //calcluate min menu center x to reach
    minCenterX = -self.view.frame.size.width/2;
    
    //set slide in NO
    isSlideIn = NO;
    
    [self setupMenuItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal
- (void)setupMenuItems{
    
    menuItems = [[NSMutableArray alloc] init];
    
    //hand set items
    [menuItems addObject:[MenuItem createMenuItem:@"Themes"]];
    [menuItems addObject:[MenuItem createMenuItem:@"Layout"]];
    [menuItems addObject:[MenuItem createMenuItem:@"History"]];
}

/**
 * Configure table view cell
 */
- (void)configureCell:(LeftMenuItemCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    MenuItem *item = [menuItems objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = item.itemTitle;
}

#pragma mark - rotation change
/**
 * Handle device rotation and layout view again
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    maxCenterX = size.width * _maxViewToShowMultiplier - size.width / 2;
    minCenterX = -size.width / 2;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        if(currentDirection == None){
            
            if(isSlideIn){
                
                [self slideInWithDuration:0 OnComplete:nil];
            }
            else{
                
                [self slideOutWithDuration:0 OnComplete:nil];
            }
        }
        
    } completion:nil];

}

/**
 * Handle device rotation and layout view again for older ios
 */
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    maxCenterX = self.view.frame.size.width * _maxViewToShowMultiplier - self.view.frame.size.width / 2;
    minCenterX = -self.view.frame.size.width/2;
    
    if(currentDirection == None){
        
        if(isSlideIn){
            
            [self slideInWithDuration:0 OnComplete:nil];
        }
        else{
            
            [self slideOutWithDuration:0 OnComplete:nil];
        }
    }
}


#pragma mark - public  interface
- (id)addToParentViewController:(UIViewController *)parent{
    
    [parent addChildViewController:self];
    
    [parent.view addSubview:self.view];
    
    //set initial view center
    self.view.center = CGPointMake(minCenterX, self.view.center.y);
    
    [self didMoveToParentViewController:parent];
    
    return self;
}

- (void)moveMenuViewWithTranslation:(CGPoint)translation{
    
    //determine user touch move to right or left base on current touch translation and last touch translation
    if(translation.x > lastTranslation.x){
        
        currentDirection = Right;
    }
    else if(translation.x < lastTranslation.x){
        
        currentDirection = Left;
    }
    
    //if user touch move to right
    if(currentDirection == Right){
        
        //if view center not greater than max center move view
        if(self.view.center.x < maxCenterX){
            self.view.center = CGPointMake(self.view.center.x+(translation.x - lastTranslation.x) * self.acceleration, self.view.center.y);
        }
        else{
            
            isSlideIn = YES;
            
            //otherwise set view's center to max center and a bit more right
            self.view.center = CGPointMake(maxCenterX+2, self.view.center.y);
        }
    }
    else if(currentDirection == Left){// if user touch move to left
        
        //if view center is greater than min center move view
        if(self.view.center.x > minCenterX){
            self.view.center = CGPointMake(self.view.center.x+(translation.x - lastTranslation.x) * self.acceleration, self.view.center.y);
        }
        else{
            
            isSlideIn = NO;
            
            //otherwise set view to min center
            self.view.center = CGPointMake(minCenterX, self.view.center.y);
        }

    }
    
    //store last touch translation
    lastTranslation = translation;
}

- (void)slideOutWithDuration:(NSTimeInterval)duration OnComplete:(void(^)())complete{
    
    //perform slide out animation
    [UIView animateWithDuration:duration animations:^{
    
        currentDirection = Left;
        
        //view should move to min center
        self.view.center = CGPointMake(minCenterX, self.view.center.y);
        
    } completion:^(BOOL finished){
    
        if(finished){
            
            isSlideIn = NO;
            
            //notify when animation finished
            if(complete != nil)
                complete();
            
            currentDirection = None;
        }
    }];
}

- (void)slideInWithDuration:(NSTimeInterval)duration OnComplete:(void(^)())complete{
    
    //perform slide in animation
    [UIView animateWithDuration:duration animations:^{
        
        currentDirection = Right;
        
        //view should move to max center
        self.view.center = CGPointMake(maxCenterX, self.view.center.y);
        
    } completion:^(BOOL finished){
        
        if(finished){
            
            isSlideIn = YES;
            
            //notify when animation finished
            if(complete != nil)
                complete();
            
            currentDirection = None;
        }
    }];

}

#pragma mark - UITableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"MenuItemCell";
    
    LeftMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        
        cell = [[LeftMenuItemCell alloc] init];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_delegate respondsToSelector:@selector(onMenuItemSelected:)]){
        
        [_delegate onMenuItemSelected:[menuItems objectAtIndex:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
