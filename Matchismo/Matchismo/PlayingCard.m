//
//  PlayingCard.m
//  Assignment1
//
//  Created by Victor, Jason M on 2/4/14.
//  Copyright (c) 2014 Victor, Jason M. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

- (NSString *) contents {
    
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit] ;
}


+ (NSArray *)validSuits {
    return @[@"♥️", @"♦️", @"♠︎", @"♣︎"];
}

- (void) setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit  = suit;
    }
}


- (NSString *) suit {
    return _suit? _suit : @"?";
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}


+ (NSUInteger) maxRank { return [[PlayingCard rankStrings] count] - 1;  }


- (void) setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}


static const int MATCH_RANK_SCORE = 4;
static const int MATCH_SUIT_SCORE = 1;

-(int) match:(NSArray *) otherCards
{
    int score = 0;
    //Only match against 1 other card for now
	    if ([otherCards count] == 1) {
        //Assuming one card for now
        PlayingCard *otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = MATCH_RANK_SCORE;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = MATCH_SUIT_SCORE;
        }
    }
    return score;
}



@end
