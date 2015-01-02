#import "TableViewController.h"

#import "Movie.h"

#import <Realm/Realm.h>

@interface TableViewController ()

@property (nonatomic, strong) RLMResults *movies;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self setMovies:[[Movie allObjects] sortedResultsUsingProperty:@"title" ascending:YES]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self movies] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Table View Cell" forIndexPath:indexPath];
    Movie *movie = [[self movies] objectAtIndex:indexPath.row];
    if (movie && cell) {
        [[cell textLabel] setText:movie.title];
        [[cell detailTextLabel] setText:movie.userName];
        [[cell imageView] setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:movie.thumbnailSmall]]]];
    }
    return cell;
}

#pragma mark - Private methods
- (void)loadData {
    // Make HTTP request to GET list of movies
    NSURL *vimeoApiURL = [NSURL URLWithString:@"http://vimeo.com/api/v2/channel/staffpicks/videos.json"];
    NSData *vimeoApiResponse = [[NSData alloc] initWithContentsOfURL:vimeoApiURL];
    NSArray *serializedResponse = [NSJSONSerialization JSONObjectWithData:vimeoApiResponse
                                                                       options:kNilOptions
                                                                          error:nil];
    
    // Store movies in Realm persistent store
    RLMRealm *defaultRealm = [RLMRealm defaultRealm];
    
    [defaultRealm beginWriteTransaction];
    
    // Perform mapping from response data to Movie model
    for (id movie in serializedResponse) {
        Movie *newMovie = [[Movie alloc] init];
        [newMovie setDuration:[movie[@"duration"] intValue]];
        [newMovie setEmbedPrivacy:movie[@"embed_privacy"]];
        [newMovie setHeight:[movie[@"height"] intValue]];
        [newMovie setMobileUrl:movie[@"mobile_url"]];
        [newMovie setMovieDescription:movie[@"description"]];
        [newMovie setMovieId:[movie[@"id"] intValue]];
        [newMovie setStatsNumberOfComments:[movie[@"stats_number_of_comments"] intValue]];
        [newMovie setStatsNumberOfLikes:[movie[@"stats_number_of_likes"] intValue]];
        [newMovie setStatsNumberOfPlays:[movie[@"stats_number_of_plays"] intValue]];
        [newMovie setTags:movie[@"tags"]];
        [newMovie setThumbnailLarge:movie[@"thumbnail_large"]];
        [newMovie setThumbnailMedium:movie[@"thumbnail_medium"]];
        [newMovie setThumbnailSmall:movie[@"thumbnail_small"]];
        [newMovie setTitle:movie[@"title"]];
        [newMovie setUploadDate:movie[@"upload_date"]];
        [newMovie setUrl:movie[@"url"]];
        [newMovie setUserId:[movie[@"user_id"] intValue]];
        [newMovie setUserName:movie[@"user_name"]];
        [newMovie setUserPortraitHuge:movie[@"user_portrait_huge"]];
        [newMovie setUserPortraitLarge:movie[@"user_portrait_large"]];
        [newMovie setUserPortraitMedium:movie[@"user_portrait_medium"]];
        [newMovie setUserPortraitSmall:movie[@"user_portrait_small"]];
        [newMovie setUserUrl:movie[@"user_url"]];
        [newMovie setWidth:[movie[@"width"] intValue]];
        
        [defaultRealm addOrUpdateObject:newMovie];
    }
    
    [defaultRealm commitWriteTransaction];
}

@end
