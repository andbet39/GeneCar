//
//  PlayableCar.h
//  GeneCar
//
//  Created by Andrea Terzani on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "car.h"

@interface PlayableCar : car
{
    float motors_speed;

}


-(void) update;
-(void) accelera;
-(void) frena;

@end
