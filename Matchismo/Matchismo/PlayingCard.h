//
//  PlayingCard.h
//  Assignment1
//
//  Created by Victor, Jason M on 2/4/14.
//  Copyright (c) 2014 Victor, Jason M. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSNumber *rankNumber;

+ (NSArray *)validSuits;
+ (NSUInteger) maxRank;

@end
