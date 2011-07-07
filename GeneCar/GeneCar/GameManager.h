//
//  GameManager.h
//  GeneCar
//
//  Created by Andrea Terzani on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "car.h"
#import "Cromosome.h"

@interface GameManager : NSObject
{

    Cromosome * cachedCromo;
    
    Cromosome * currentCromo;


}

-(void)saveCromosome:(Cromosome*)obj key:(NSString*)key;

-(Cromosome*)loadCromosomeWithKey:(NSString*)key;

@property(readwrite) Cromosome * cachedCromo;
@property(readwrite) Cromosome * currentCromo;

@end
