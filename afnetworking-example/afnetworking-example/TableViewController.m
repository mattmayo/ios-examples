#import "TableViewController.h"

#import "Movie.h"

#import <AFNetworking/AFNetworking.h>

@interface TableViewController ()

@property (nonatomic, strong) NSMutableArray *movies;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://vimeo.com/api/v2/channel/staffpicks/videos.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [requestOperation setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                // map objects here
                                                [self setMovies:[[NSMutableArray alloc] initWithCapacity:50]];
                                                for (NSDictionary *vimeoMovie in responseObject) {
                                                    Movie *movie = [[Movie alloc] init];
                                                    [movie setTitle:[vimeoMovie objectForKey:@"title"]];
                                                    [movie setUser:[vimeoMovie objectForKey:@"user_name"]];
                                                    [movie setUrlThumbnailSmall:[vimeoMovie objectForKey:@"thumbnail_small"]];
                                                    [[self movies] addObject:movie];
                                                }
                                                [[self tableView] reloadData];
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                NSLog(@"Error: %@", error);
                                            }];
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
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
        [[cell detailTextLabel] setText:movie.user];
        [[cell imageView] setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:movie.urlThumbnailSmall]]]];
    }
    
    return cell;
}



@end
