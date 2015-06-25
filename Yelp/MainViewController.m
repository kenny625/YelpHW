//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSMutableArray *filteredBusinesses;

-(void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self fetchBusinessWithQuery:@"Restaurants" params:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.searchBar.showsCancelButton = YES;
    self.navigationItem.titleView = self.searchBar;
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.searchBar action:@selector(resignFirstResponder)]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredBusinesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.filteredBusinesses[indexPath.row];
    return cell;
}


-(void)onFilterButton {
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)filtersViewController:(FilterViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    [self fetchBusinessWithQuery:@"Restaurants" params:filters];
}

- (void)fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params {
    [self.client searchWithTerm:@"Thai" params:params success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"response: %@", response);
        NSArray *businessDictionares = response[@"businesses"];
        self.businesses = [Business businessWithDictionaries:businessDictionares];
        self.filteredBusinesses = self.businesses;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchText = searchBar.text;
    self.filteredBusinesses = [NSMutableArray array];
    for (Business *business in self.businesses) {
        if ([business.name containsString:searchBar.text]) {
            [self.filteredBusinesses addObject:business];
        }
    }
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if([searchText isEqualToString:@""] || searchText == nil) {
        self.filteredBusinesses = self.businesses;
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.filteredBusinesses = self.businesses;
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}
@end
