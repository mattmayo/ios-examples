#import <CoreData/CoreData.h>

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * embedPrivacy;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * mobileUrl;
@property (nonatomic, retain) NSString * movieDescription;
@property (nonatomic, retain) NSNumber * movieId;
@property (nonatomic, retain) NSNumber * statsNumberOfComments;
@property (nonatomic, retain) NSNumber * statsNumberOfLikes;
@property (nonatomic, retain) NSNumber * statsNumberOfPlays;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * thumbnailLarge;
@property (nonatomic, retain) NSString * thumbnailMedium;
@property (nonatomic, retain) NSString * thumbnailSmall;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * uploadDate;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userPortraitHuge;
@property (nonatomic, retain) NSString * userPortraitLarge;
@property (nonatomic, retain) NSString * userPortraitMedium;
@property (nonatomic, retain) NSString * userPortraitSmall;
@property (nonatomic, retain) NSString * userUrl;
@property (nonatomic, retain) NSNumber * width;

@end
