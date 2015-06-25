//
//  FilterViewController.h
//  Yelp
//
//  Created by Kenny Chu on 2015/6/22.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void)filtersViewController:(FilterViewController *) filtersViewController didChangeFilters:(NSDictionary *)filters;

@end

@interface FilterViewController : UIViewController

@property(nonatomic, weak) id<FiltersViewControllerDelegate> delegate;

@end
