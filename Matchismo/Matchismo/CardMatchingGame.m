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
@property (nonatomic) int gameMode; //# of cards to match
@end


@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
static const int PARTIAL_MATCH = 2;

@synthesize gameMode = _gameMode;

-(int) gameMode {
    if (!_gameMode) { _gameMode = 2; }
    return _gameMode;
}

-(void) setGameMode:(int)matchCount {
    //default is 2; 2 or 3 is valid; check for invalid values
    _gameMode = 2;
    
    NSArray * validMatchModes = @[@2, @3];
    
    for (NSNumber *mode in validMatchModes) {
        if ((int)mode == (int)matchCount) {
            _gameMode = (int)mode;
            break;
        }
    }
    NSLog(@"game mode = %d matches", self.gameMode);
}


-(NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(void) resetGame {
    self.score = 0;
    self.cards = nil;
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



- (void) chooseCardAtIndex:(NSUInteger)index {
    
    Card *card = [self cardAtIndex:index];
    NSMutableArray * selectedCards = [[NSMutableArray alloc] init];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO; // what does this do?
        }
        else {
            for (Card *otherCard in self.cards) {
                
                if (otherCard.isChosen && !otherCard.isMatched) {
                    
                    //Add the card to the matched array (you need this for displaying attempts)
                    [selectedCards addObject:otherCard];
                    
                    int matchScore = [card match:(Card *)@[otherCard]];
                    if (matchScore) {
                        otherCard.matched = YES;
                        card.matched = YES;
                    }
                    
                }
            }
            
            
            
            //If enough cards are chosen...
            NSLog(@"selectedCardsCount = %d", selectedCards.count);
            NSLog(@"gameMode = %d", self.gameMode);

            if (selectedCards.count >= self.gameMode-1) {
                
                int matchScore = [card match:(Card *)selectedCards];  // send all selected cards to the matcher

                NSLog(@"matchScore = %d", matchScore);

                self.score += matchScore;
                
                //if there's a match, figure out score
                if (matchScore) {
                    //if there were matches but matches were lower than possible, give partial credit
                    if (matchScore < (int)self.gameMode-1) {
                        self.score += matchScore * PARTIAL_MATCH;
                    }
                    else { //give full bonus
                        self.score += matchScore * MATCH_BONUS;
                    }
                 
                    //if any are matched, all can no longer be picked
                    for (Card * selectedCard in selectedCards) {
                        selectedCard.matched = YES;
                    }
                    
                } else { // no matches
                    NSLog(@"No Matches");
                    self.score -= MISMATCH_PENALTY;
                    //Reset the cards
                    
                    for (Card * notMatchingCard in selectedCards) {
                        notMatchingCard.chosen = NO; //flip back over
                        notMatchingCard.matched = NO;
                    }
                }
            }
        }
        self.score -= COST_TO_CHOOSE;
        card.chosen = YES;
    }
    
}




@end
