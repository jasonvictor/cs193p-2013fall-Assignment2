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
    NSLog(@"game mode = %@ matches", self.gameMode);
}

-(NSNumber *) getGameMode {
    if (!_gameMode) { _gameMode = @2; }
    return _gameMode;
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

    /*
    if (card) {
        selectedCards = [[NSMutableArray alloc] initWithArray:@[card]];
    }
     */
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
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
            
            int matchScore = [card match:(Card *)selectedCards];  // send all selected cards to the matcher
            self.score += matchScore;
            
            
            //If enough cards are chosen...
            if ((int)self.gameMode <= selectedCards.count-1) {
                
                //if there's a match, figure out score
                if (matchScore) {
                    //if there were matches but matches were lower than possible, give partial credit
                    if (matchScore < (int)self.gameMode) {
                        self.score += matchScore * PARTIAL_MATCH;
                    }
                    else { //give full bonus
                        self.score += matchScore * MATCH_BONUS;
                    }
                 
                    //Mark
                    
                } else {
                    self.score -= MISMATCH_PENALTY;
                    //Reset the cards
                    //card.chosen = NO;
                    for (Card * notMatchingCard in selectedCards) {
                        notMatchingCard.chosen = NO;
                        //notMatchingCard.matched = NO;
                    }
                }
                
            }
        }
        self.score -= COST_TO_CHOOSE;
        card.chosen = YES;
    }
    
}




@end
