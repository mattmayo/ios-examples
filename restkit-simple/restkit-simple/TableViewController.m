#import "TableViewController.h"

#import "Movie.h"

#import <RestKit/RestKit.h>

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSArray *movies;

@end

@implementation TableViewController

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];

    // Setup fetch request from the local CoreData source
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    // if you want to limit the results set
    //[fetchRequest setFetchLimit:1];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:[[RKManagedObjectStore defaultStore] mainQueueManagedObjectContext]
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    // Register this class for changes in the results
    [fetchedResultsController setDelegate:self];
    
    // Fetch data from CoreData source
    NSError *error = nil;
    BOOL fetchSuccessful = [fetchedResultsController performFetch:&error];
    NSAssert(fetchSuccessful, error.description);
    [self setMovies:[fetchedResultsController fetchedObjects]];
    
    // Load fresh data
    [self loadData];
}

#pragma mark - UITableViewDelegate methods

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

#pragma mark - NSFectedResultsControllerDelegate methods

// When a change in the data set occurs based on what we fetched, this gets called
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self setMovies:[controller fetchedObjects]];
    [[self tableView] reloadData];
}

#pragma mark - Private methods

- (void)loadData {
    // Initiates a HTTP GET request to http://vimeo.com/api/v2/channel/staffpicks/videos.json
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/v2/channel/staffpicks/videos.json"
                                           parameters:nil
                                              success:nil
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Failure getting videos: %@", error);
                                              }];
}

@end
