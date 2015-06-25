//
//  SwitchCell.h
//  Yelp
//
//  Created by Kenny Chu on 2015/6/22.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol switchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL on;
@property(nonatomic, weak)id<switchCellDelegate> delegate;

- (void)setOn:(BOOL)on animated:(BOOL)animated;
@end
