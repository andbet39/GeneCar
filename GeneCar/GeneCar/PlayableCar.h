//
//  PlayableCar.h
//  GeneCar
//
//  Created by Andrea Terzani on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "car.h"
#import "GeneticConfig.h"

#import "SoundEngine.h"

@interface PlayableCar : car
{
    float motors_speed;
    
    SoundEngine *se;
    float audio_time;
}


-(void) update;
-(void) accelera;
-(void) frena;
-(float) getSpeed;

@end
