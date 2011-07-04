//
//  GameManager.m
//  GeneCar
//
//  Created by Andrea Terzani on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager
SYNTHESIZE_SINGLETON_FOR_CLASS(GameManager);
@synthesize cachedCromo,currentCromo;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
