//
//  AppEngine.m
//  Phonder
//

#import "AppEngine.h"
#import "Constants.h"
#import "NSData+Base64.h"


@implementation AppEngine
@synthesize gPersonInfo     = _gPersonInfo;
@synthesize mProfilePhotoUrl;

@synthesize gPopedView = gPopedView;
@synthesize isBackAction = _isBackAction;
@synthesize gSrvTime        = _gSrvTime;
@synthesize gUserCurrentLatitude = _gUserCurrentLatitude;
@synthesize gUserCurrentLongitude = _gUserCurrentLongitude;
@synthesize gContentBorderColor;
@synthesize gUserSetting;
@synthesize bUserSettingChanged;
@synthesize gCurrentMessageHistory;
@synthesize gNewMessagesCount;

#pragma mark singleton

+ (id)getInstance {
    static AppEngine * instance = nil;
    if (!instance) {
        instance = [[AppEngine alloc] init];

    }
    return instance;
}
#pragma mark init

- (id)init {
    if (self = [super init]) {
        _gPersonInfo    = [[JUserInfo alloc] init];
        gUserSetting = [[JUserSetting alloc]init];
        
        self.soundMeters=[[NSMutableArray alloc] initWithCapacity:80];
      //        _soundMeters set
    }
    gContentBorderColor =  [UIColor colorWithRed:0/255.0 green:204/255.0 blue:255/255.0 alpha:1.0];
    return self;
}


#pragma mark -
#pragma mark BLL general

- (void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setPopedView :(NSString *)value
{
    gPopedView = value;
}
- (id)valueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
#pragma mark -
#pragma mark - Base64
- (NSString *)base64Encode:(NSString *)plainText
{
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainTextData base64EncodedString];
    return base64String;
}
- (NSString *)base64Decode:(NSString *)base64String
{
    NSData *plainTextData = [NSData dataFromBase64String:base64String];
    NSString *plainText = [[NSString alloc] initWithData:plainTextData encoding:NSUTF8StringEncoding];
    return plainText;
}
- (void)setProfilePhotoUrl : (NSString*)photoUrl
{
    mProfilePhotoUrl = photoUrl;
}

+(void)showServiceUnavailableAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Warning" message: @"Service unavailable" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alertView show];

}
+ (UIColor *) colorFromString:(NSString *)colorStr
{
    NSScanner *scanner=[NSScanner scannerWithString:colorStr];
    unsigned int colorInt;
    [scanner setScanLocation:1];
    [scanner scanHexInt:&colorInt];
    //    NSLog(@"Color From String: %@, As Int: %d",colorStr,colorInt);
    UIColor *color=[UIColor colorWithRed:colorInt/256/256.0/255.0 green:((colorInt/256)%256)/255.0 blue:(colorInt%256)/255.0
                                   alpha:1.0];
    return color;
}

+(void)showServiceUnavailableAlert :(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Warning" message: msg delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    [alertView show];
}
+(NSString *) getTimeOffsetStr :(NSInteger )delta
{
    const int SECOND = 1;
    const int MINUTE = 60 * SECOND;
    const int HOUR = 60 * MINUTE;
    const int DAY = 24 * HOUR;
    const int MONTH = 30 * DAY;
    
    
    if (delta < 0)
    {
        return @"just ago";
    }
    if (delta < 1 * MINUTE)
    {
        return delta == 1 ? @"1s ago" : [NSString stringWithFormat:@"%ld%@",(long)delta,@"s ago"];
    }
    if (delta < 2 * MINUTE)
    {
        return @"1m ago";
    }
    if (delta < 45 * MINUTE)
    {
        return [NSString stringWithFormat:@"%d%@", (int)floor(delta / 60)  , @"m ago"];
    }
    if (delta < 90 * MINUTE)
    {
        return @"1h ago";
    }
    if (delta < 24 * HOUR)
    {
        return [NSString stringWithFormat:@"%d%@", (int)floor(delta / 60 / 60) , @"h ago"];
        
    }
    if (delta < 48 * HOUR)
    {
        return @"1 day ago";
    }
    if (delta < 30 * DAY)
    {
        return [NSString stringWithFormat:@"%d%@", (int)floor(delta / 60 / 60 / 24) , @"d ago"];
        
    }
    if (delta < 12 * MONTH)
    {
        int months = floor((double)floor(delta / 60 / 60 / 24)/ 30);
        return months <= 1 ? @"1 month ago" : [NSString stringWithFormat:@"%d %@", months , @" months ago" ];
        
    }
    else
    {
        int years = floor((double)floor(delta / 60 / 60 / 24)/ 365);
        return years <= 1 ? @"1 year ago" :   [NSString stringWithFormat:@"%d %@", years , @" years ago" ];
    }
}
+ (BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    
    //    NSLog(@"%lu", (unsigned long)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
    
}
+(CGSize)messageSize:(NSString*)message font:(UIFont*)font  width:(NSInteger)width
{
    CGSize sz=[message boundingRectWithSize:CGSizeMake(width, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil].size;
    return sz;
}

+ (UIImage*)blurWithCoreImage:(UIImage *)sourceImage viewController:(UIViewController *)viewController;
{
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    // Apply Affine-Clamp filter to stretch the image so that it does not
    // look shrunken when gaussian blur is applied
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKey:@"inputImage"];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Apply gaussian blur filter with radius of 30
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName: @"CIGaussianBlur"];
    [gaussianBlurFilter setValue:clampFilter.outputImage forKey: @"inputImage"];
    [gaussianBlurFilter setValue:@30 forKey:@"inputRadius"];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:gaussianBlurFilter.outputImage fromRect:[inputImage extent]];
    
    // Set up output context.
    UIGraphicsBeginImageContext(viewController.view.frame.size);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    
    // Invert image coordinates
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -viewController.view.frame.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, viewController.view.frame, cgImage);
    
    // Apply white tint
    CGContextSaveGState(outputContext);
    CGContextSetFillColorWithColor(outputContext, [UIColor colorWithWhite:1 alpha:0.4].CGColor);
    CGContextFillRect(outputContext, viewController.view.frame);
    CGContextRestoreGState(outputContext);
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (NSInteger)ageFromBirthday:(NSDate *)birthdate {
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}


@end
