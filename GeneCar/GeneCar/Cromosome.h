//
//  Cromosome.h
//  GeneCar
//
//  Created by Andrea Terzani on 01/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"

#import "GeneticConfig.h"


@interface Cromosome:NSObject 
{
@public
     
    b2Vec2 body_vector[VERT_NUM];
    
    int ver_wheel0;
    int ver_wheel1;
    
    float radius_wheel0;
    float radius_wheel1;
    
    float angle_wheel0;
    float angle_wheel1;
    
    float score;
    int vote;
    
    
}


- (id) initRandom ;
-(id)initWithCromosome :(Cromosome *)C;
-(void)muta;


@end
