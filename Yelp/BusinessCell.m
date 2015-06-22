//
//  BusinessCell.m
//  Yelp
//
//  Created by Kenny Chu on 2015/6/22.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImg;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;


@end

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
    
    self.thumbImg.layer.cornerRadius = 3;
    self.thumbImg.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusiness:(Business *)business {
    _business = business;
    [self.thumbImg setImageWithURL:[NSURL URLWithString:self.business.imgUrl]];
    self.nameLabel.text = self.business.name;
    [self.ratingImg setImageWithURL:[NSURL URLWithString:self.business.ratingImgUrl]];
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
    self.addressLabel.text = self.business.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
}

@end
