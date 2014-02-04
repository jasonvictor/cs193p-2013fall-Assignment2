//
//  Deck.h
//  Assignment1
//
//  Created by Victor, Jason M on 2/4/14.
//  Copyright (c) 2014 Victor, Jason M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject


- (void) addCard:(Card *)card atTop:(BOOL) atTop;

- (void) addCard:(Card *)card;

- (Card *) drawRandomCard;



@end
