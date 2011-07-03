//
//  Track.h
//  GeneCar
//
//  Created by Andrea Terzani on 29/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "GeneticConfig.h"

@interface Track : NSObject
{
    b2Body* groundBody;
}

- (void) generaRandom : (b2World *)world;
- (void) draw;
-(void)generaSaved : (b2World *)world;

@end
