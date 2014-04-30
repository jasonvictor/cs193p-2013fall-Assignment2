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

//Had to create a reusable way to get at the rank in an "object" form
- (NSNumber *) rankNumber {
    return [[NSNumber alloc] initWithUnsignedInteger:self.rank];
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

//Overridden to deal with playing card match detection
-(int) match:(NSArray *) otherCards
{
    int score = 0;

    if ([otherCards count] > 0) {

        int totalCards = otherCards.count + 1;
        NSCountedSet *rankSet = [[NSCountedSet alloc] init];
        NSCountedSet *suitSet = [[NSCountedSet alloc] init];
        [rankSet addObject:self.rankNumber];
        [suitSet addObject:self.suit];
        
        //Put all Ranks in one "bag" & suits in another
        for (PlayingCard * otherCard in otherCards) {
            [rankSet addObject:otherCard.rankNumber];
            [suitSet addObject:otherCard.suit];
        }
        
        //How many Ranks and suits match?
        // total cards - (# of unique items in the set) + 1
        int rankMatches = totalCards - rankSet.count + 1;
        int suitMatches = totalCards - suitSet.count + 1;
        
        if (rankMatches > 1) { score += MATCH_RANK_SCORE * rankMatches;}
        else if (suitMatches > 1) { score += MATCH_SUIT_SCORE *suitMatches; }
        
    }
    
    return score;
}

- (NSString *) description {
    return self.contents;
}



@end
