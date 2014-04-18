//
//  CardMatchingGame.m
//  Assignment1
//
//  Created by Victor, Jason M on 2/21/14.
//  Copyright (c) 2014 Victor, Jason M. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of card
@property (nonatomic, strong) NSNumber * gameMode; //# of cards to match
@end


@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
static const int PARTIAL_MATCH = 2;

-(NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(void) resetGame {
    self.score = 0;
    self.cards = nil;
}

-(void) setGameMode:(NSNumber *)matchCount {
    //default is 2; 2 or 3 is valid; check for invalid values
    _gameMode = @2;
    NSArray * validMatchModes = @[@2, @3];
    for (NSNumber *mode in validMatchModes) {
        if ([mode isEqualToNumber:matchCount]) {
            _gameMode = mode;
            break;
        }
    }
    //NSLog(@"game mode = %@ cards", self.gameMode);
}

- (instancetype) initWithCardCount:(NSUInteger)count
                         usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject: card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

-(Card *) cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

//TODO - implement change in logic for matches w/ three cards
- (void) chooseCardAtIndex:(NSUInteger)index {
    
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            //match against other chosen cards
            
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    
                    int matchScore = [card match:@[otherCard]];
                                      
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        otherCard.matched = YES;
                        card.matched = YES;
                    }
                    else {
                        self.score -= MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                        //if we allow more than 2 card matches, we might not want to do this.
                    }
                    break; //can only choose 2 cards for now
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }

    }
    
}



@end
