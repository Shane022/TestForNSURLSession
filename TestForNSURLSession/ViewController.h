//
//  ViewController.h
//  TestForNSURLSession
//
//  Created by new on 16/10/12.
//  Copyright © 2016年 new. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSession;
@property (weak, nonatomic) IBOutlet UIButton *btnConnection;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UIButton *btnSessionDownload;


- (IBAction)onHitBtnSendRequestWithSession:(id)sender;
- (IBAction)onHitbtnSendRequestWithConnection:(id)sender;
- (IBAction)onHitBtnDownload:(id)sender;

@end

