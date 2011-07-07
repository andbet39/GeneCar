//
//  HUDLayer.h
//  GeneCar
//
//  Created by Andrea Terzani on 02/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface HUDLayer : CCLayer
{


    CCLabelTTF *scoreLabel;
    CCLabelTTF *generLabel;
    CCLabelTTF *avgLabel;
    
    NSMutableArray *list_label;
    
    float score;
    float avgFitness;
    int generation;
    
    
    int list_y;
    int list_elem;
    int list_x;
    
}
@property(readwrite) float score;
@property(readwrite) int generation;
@property(readwrite) float avgFitness;

- (void)addListScore:(float) score;

@end
