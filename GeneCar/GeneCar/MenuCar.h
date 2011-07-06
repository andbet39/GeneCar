//
//  MenuCar.h
//  GeneCar
//
//  Created by Andrea Terzani on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "car.h"
#import "GeneticConfig.h"


@interface MenuCar : car
{
    float scale;
}

@property(readwrite) float scale;

@end
