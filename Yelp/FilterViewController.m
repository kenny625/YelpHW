//
//  FilterViewController.m
//  Yelp
//
//  Created by Kenny Chu on 2015/6/22.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SwitchCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, switchCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *sorts;
@property (nonatomic, strong) NSArray *radius;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSMutableSet *selectedSort;
@property (nonatomic, strong) NSMutableSet *selectedRadius;
@property (nonatomic, assign) BOOL deal;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self initArrays];
        self.selectedCategories = [NSMutableSet set];
        self.selectedSort = [NSMutableSet set];
        self.selectedRadius = [NSMutableSet set];
        [self.selectedSort addObject:self.sorts[0]];
        self.deal = FALSE;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyButton)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initArrays {
    self.categories = @[@{@"name":@"Afghan",@"code":@"afghani"},
                        @{@"name":@"African",@"code":@"african"},
                        @{@"name":@"American, New",@"code":@"newamerican"}
                        ];
    self.sorts = @[@{@"name":@"Best matched",@"code":@"0"},
                    @{@"name":@"Distance",@"code":@"1"},
                    @{@"name":@"Highest Rated",@"code":@"2"}];
    self.radius = @[@{@"name":@"500 meters",@"code":@"500"},
                    @{@"name":@"1000 meters",@"code":@"1000"},
                    @{@"name":@"1500 meters",@"code":@"1500"},
                    @{@"name":@"2000 meters",@"code":@"2000"}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger countNum;
    switch (section) {
        case 0:
            countNum = self.categories.count;
            break;
        case 1:
            countNum = self.sorts.count;
            break;
        case 2:
            countNum = self.radius.count;
            break;
        case 3:
            countNum = 1;
            break;
        default:
            break;
    }
    return countNum;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    switch (section) {
        case 0:
            title = @"Category";
            break;
        case 1:
            title = @"Sort";
            break;
        case 2:
            title = @"Radius";
            break;
        case 3:
            title = @"Deals";
            break;
        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    
    switch (indexPath.section) {
        case 0:
            cell.titleLabel.text = self.categories[indexPath.row][@"name"];
            cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
            break;
        case 1:
            cell.titleLabel.text = self.sorts[indexPath.row][@"name"];
            cell.on = [self.selectedSort containsObject:self.sorts[indexPath.row]];
            break;
        case 2:
            cell.titleLabel.text = self.radius[indexPath.row][@"name"];
            cell.on = [self.selectedRadius containsObject:self.radius[indexPath.row]];
            break;
        case 3:
            cell.titleLabel.text = @"Offering a deal";
            cell.on = self.deal;
        default:
            break;
    }
    
    cell.delegate = self;
    return cell;
}

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (indexPath.section) {
        case 0:
            if (value) {
                [self.selectedCategories addObject:self.categories[indexPath.row]];
            } else {
                [self.selectedCategories removeObject:self.categories[indexPath.row]];
            }
            break;
        case 1:
            self.selectedSort = [NSMutableSet set];
            if (value) {
                [self.selectedSort addObject:self.sorts[indexPath.row]];
            } else {
                [self.selectedSort addObject:self.sorts[0]];
            }
            [self.tableView reloadData];
            break;
        case 2:
            self.selectedRadius = [NSMutableSet set];
            if (value) {
                [self.selectedRadius addObject:self.radius[indexPath.row]];
            }
            [self.tableView reloadData];
            break;
        case 3:
            if (value) {
                self.deal = TRUE;
            } else {
                self.deal = FALSE;
            }
            
        default:
            break;
    }
    
    
}

- (NSDictionary *)filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
        }
        NSString *categoryFilter = [names componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    [filters setObject:[self.selectedSort allObjects][0][@"code"] forKey:@"sort"];
    if (self.selectedRadius.count != 0) {
        [filters setObject:[self.selectedRadius allObjects][0][@"code"] forKey:@"radius_filter"];
    }
    [filters setObject:(self.deal) ? @"true" : @"false" forKey:@"deals_filter"];
    return filters;
}

@end
