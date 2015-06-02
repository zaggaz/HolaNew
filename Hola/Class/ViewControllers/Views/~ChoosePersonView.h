
#import <UIKit/UIKit.h>
#import "MDCSwipeToChoose.h"

@class Person;

@interface ChoosePersonView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) Person *person;

- (instancetype)initWithFrame:(CGRect)frame
                       person:(Person *)person
                      options:(MDCSwipeToChooseViewOptions *)options;

@end
