
#ifndef Contants_h
#define Contants_h

#define APP_NAME [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]

// Web APIs


//

#define WEB_SERVICES_URL              @"http://192.168.2.106/hola/webservice/webservice.php"
#define WEB_SITE_BASE_URL              @"http://192.168.2.106/hola/"


//#define WEB_SERVICES_URL                @"http://whitesyndicateapps.com/hola/webservice/webservice.php"
//#define WEB_SITE_BASE_URL               @"http://whitesyndicateapps.com/hola/"
//#define WEB_SERVICES_URL                @"http://localhost:8888/Hola/hola_backend2/webservice/webservice.php"
//#define WEB_SITE_BASE_URL               @"http://localhost:8888/Hola/hola_backend2/"
//#define WEB_SERVICES_URL                @"http://service.letshola.com/webservice/webservice.php"
//#define WEB_SITE_BASE_URL               @"http://service.letshola.com/"

#define WEB_SERVICE_RELATIVE_URL        @"webservice/webservice.php"

#endif

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define RECORD_SEND_VIDEO                      @"RECORD_SEND_VIDEO"
#define RECORD_SEND_AUDIO                      @"RECORD_SEND_AUDIO"
#define RECORD_SEND_PHOTO                      @"RECORD_SEND_PHOTO"
#define RECORD_PROFILE_VIDEO                   @"RECORD_PROFILE_VIDEO"
#define RECORD_PROFILE_PHOTO                   @"RECORD_PROFILE_PHOTO"
#define RECORD_PROFILE_MAIN_PHOTO              @"RECORD_PROFILE_MAIN_PHOTO"
#define PREFERED_WITH 640.0
#define PREFERED_HEIGHT 1136.0



#define kTempMoviePath		([NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.mov"])
#define kTempMoviePathCompressed		([NSTemporaryDirectory() stringByAppendingPathComponent:@"comp_temp.mov"])
#define kTempMovieURL		([NSURL fileURLWithPath:kTempMoviePath])
#define kTempMovieURLCompressed		([NSURL fileURLWithPath:kTempMoviePathCompressed])

#define HOME_LEFTBTN_TOUCH                    @"HOME_LEFTBTN_TOUCH"
#define HOME_RIGHTBTN_TOUCH                   @"HOME_RIGHTBTN_TOUCH"

#define PANEL_LEFT_WILL_SHOW                  @"PANEL_LEFT_WILL_SHOW"
#define PANEL_RIGHT_WILL_SHOW                 @"PANEL_RIGHT_WILL_SHOW"
#define CLOSE_SIDE_VIEW                       @"CLOSE_SIDE_VIEW"
#define SHOW_MAIN_VIEW                        @"SHOW_MAIN_VIEW"
#define SHOW_TAB_ITEM                         @"SHOW_TAB_ITEM"
#define SHOW_SETTING_VIEW                     @"SHOW_SETTING_VIEW"
#define SHOW_MAIN_HOME                        @"SHOW_MAIN_HOME"

#define SHOW_FRIEND_LIST_VIEW                 @"SHOW_FRIEND_LIST_VIEW"
#define SHOW_LOCATION                 @"SHOW_LOCATION"
#define SHOW_CHAT_VIEW                        @"SHOW_CHAT_VIEW"
#define SHOW_MATCH_VIEW                       @"SHOW_MATCH_VIEW"

#define SHOW_PROFILE                          @"SHOW_PROFILE"
#define NOTIFICATION_LOGOUT                   @"NOTIFICATION_LOGOUT"
#define PROFILE_PICTURE_CHANGED               @"PROFILE_PICTURE_CHANGED"

#define NOTIFICATION_SETTING                  @"NOTIFICATION_SETTING"
#define GENERAL_SETTING                       @"GENERAL_SETTING"
#define ADD_RECOMMENDATION                    @"ADD_RECOMMENDATION"
#define GET_ADVICE                            @"GET_ADVICE"
#define ACCOUNT_SETTING                       @"ACCOUNT_SETTING"




#define MSG_COMMENT_LONG                @"Your comment was too long, so we trimmed it to 500 characters."


#define MAP_SHOW_DISTANCE_FOR_PLACE         0.005
#define MAP_SHOW_DISTANCE_FOR_ANONYMOUSE         0.1

#define GOOGLE_API_KEY                  @"AIzaSyAmRfBs0UttPCPlyvUv2RwNxnLfkKpJIh0"

#define IS_IPHONE5 ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568) ? YES : NO )
#define SCREEN_HEIGHT ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568) ? 568 : 480 )




#define MSG_SERVICE_UNAVAILABLE @"Sorry! Service is not available now."
#define MSG_INVALID_TOKEN @"Your login has expired, please login again."

#define MSG_LOADING             @"Loading..."
#define MSG_WAITING             @"Waiting..."
#define MSG_WAIT    @"Please wait..."
#define MSG_SAVING              @"Saving..."



#define MSG_REGISTER_ALREADY_SIGNED_USER @"The email was already registered!"
#define MSG_PASSWORD_SHOULD_NOT_EMPTY @"Please enter password."
#define MSG_CONFIRM_PASSWORD_SHOULD_NOT_EMPTY @"Please enter your password again."
#define MSG_PASSWORD_CONFIRM_NOT_MATCH @"Password confirmation doesn't match."


#define MSG_REGISTER_EMAIL_ADDRESS_NOT_VALID @"Please enter valid email address."
#define MSG_LOGIN_EMAIL_PASSWORD_NOT_MATCH @"Please enter valid email or password."
#define MSG_PASSWORD_SHOULD_NOT_EMPTY @"Please enter password."
#define MSG_FIRSTNAME_SHOULD_NOT_EMPTY @"Please enter first name."
#define MSG_LASTNAME_SHOULD_NOT_EMPTY @"Please enter last name."


#define SETTING_MIN_AGE     15
#define SETTING_MAX_AGE     59
#define SETTING_MIN_DISTANCE 0
#define SETTING_MAX_DISTANCE 1000

#define NOTIFICATION_SETTING_CHANGED          @"NOTIFICATION_SETTING_CHANGED"
#define UPDATE_TOP_BADGE                      @"UPDATE_TOP_BADGE"




