#import <Realm/Realm.h>

@interface Movie : RLMObject

@property int duration;
@property NSString * embedPrivacy;
@property int height;
@property NSString * mobileUrl;
@property NSString * movieDescription;
@property int movieId;
@property int statsNumberOfComments;
@property int statsNumberOfLikes;
@property int statsNumberOfPlays;
@property NSString * tags;
@property NSString * thumbnailLarge;
@property NSString * thumbnailMedium;
@property NSString * thumbnailSmall;
@property NSString * title;
@property NSString * uploadDate;
@property NSString * url;
@property int userId;
@property NSString * userName;
@property NSString * userPortraitHuge;
@property NSString * userPortraitLarge;
@property NSString * userPortraitMedium;
@property NSString * userPortraitSmall;
@property NSString * userUrl;
@property int width;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Movie>
RLM_ARRAY_TYPE(Movie)
