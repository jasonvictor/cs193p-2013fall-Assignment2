//
//  GameCardViewController.m
//  Assignment1
//
//  Created by Victor, Jason M on 2/4/14.
//  Copyright (c) 2014 Victor, Jason M. All rights reserved.
//

#import "GameCardViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface GameCardViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation GameCardViewController

- (CardMatchingGame *) game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[self createDeck] ];
    return _game;
}


- (Deck *) createDeck {
    return [[PlayingCardDeck alloc] init];
}


- (IBAction)touchCardButton:(UIButton *)sender {

    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

-(void) updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
    
}
- (IBAction)redealButton:(UIButton *)sender {
    [self.game resetGame];
    [self updateUI];
    self.game = nil;
}

-(NSString *) titleForCard:(Card *)card {
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundImageForCard:(Card *)card {
    return [UIImage imageNamed:card.isChosen ? @"cardfront": @"cardback"];
}


@end
