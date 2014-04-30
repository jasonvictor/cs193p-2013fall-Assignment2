//
//  Card.h
//  Assignment1
//
//  Created by Victor, Jason M on 2/4/14.
//  Copyright (c) 2014 Victor, Jason M. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString * contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;


- (int) match: (Card *) card;







 










@end

