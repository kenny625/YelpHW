//
//  Business.h
//  Yelp
//
//  Created by Kenny Chu on 2015/6/22.
//  Copyright (c) 2015年 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImgUrl;
@property (nonatomic, assign) NSInteger numReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, assign) CGFloat distance;

+ (NSArray *)businessWithDictionaries:(NSArray *)dictionaries;

@end
