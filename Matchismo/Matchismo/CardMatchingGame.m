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

#define DEFAULT_GAME_MODE 2;

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;
static const int PARTIAL_MATCH = 2;
static const int PARTIAL_THRESHOLD = 10;

@synthesize gameMode = _gameMode;

-(int) gameMode {
    if (!_gameMode) { _gameMode = 2; }
    return _gameMode;
}

-(void) setGameMode:(int)matchCount {
    // Check for invalid values
    _gameMode = DEFAULT_GAME_MODE;
    
    NSArray * validMatchModes = @[@2, @3];
    
    for (NSNumber *mode in validMatchModes) {
        if ([mode intValue] == matchCount) {
            _gameMode = [mode intValue];
            break;
        }
    }
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


//Changed this to return a String with the results.
// The game would know best the rules on scoring
// Alternative approach would have been to keep a publically accessible property called "lastRestlt"
// and allow the calling method get that separately.

- (NSString *) chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    NSString * returnMsg = card.description;
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
                    returnMsg = [NSString stringWithFormat:@"%@%@",  [selectedCards  componentsJoinedByString:@" "], card];
                    
                    
                }
            }
            
            
            //If enough cards are chosen...
            int changeInScore = 0;

            if (selectedCards.count >= self.gameMode-1) {
                
                int matchScore = [card match:(Card *)selectedCards];  // send all selected cards to the matcher

                self.score += matchScore;
                changeInScore += matchScore;
                
                //if there's a match, figure out score
                if (matchScore) {
                    card.matched = YES;

                    //if there were matches but score is lower than some possible threshold, give partial credit
                    if (matchScore < PARTIAL_THRESHOLD) {
                        self.score += matchScore + PARTIAL_MATCH;
                        changeInScore += matchScore + PARTIAL_MATCH;
                    }
                    else { //give full bonus
                        self.score += matchScore + MATCH_BONUS;
                        changeInScore += matchScore + MATCH_BONUS;
                    }

                    returnMsg = [NSString stringWithFormat:@"%@%@ Matched for %d points!", [selectedCards  componentsJoinedByString:@" "], card, changeInScore];
                 
                    //if any are matched, all can no longer be picked
                    for (Card * selectedCard in selectedCards) {
                        selectedCard.matched = YES;
                    }
                    
                } else { // no matches
                    self.score -= MISMATCH_PENALTY;

                    returnMsg = [NSString stringWithFormat:@"%@%@ No Match %d penalty!", [selectedCards  componentsJoinedByString:@" "], card,MISMATCH_PENALTY];
                    
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
    return returnMsg;
}




@end
