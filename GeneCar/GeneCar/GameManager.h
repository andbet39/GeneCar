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
    
    Cromosome *bestEver;
    
    
    NSString * selected_track;
    
    NSString *nextAction;
    
    bool garageSaveMode;


}

-(void)saveCromosome:(Cromosome*)obj key:(NSString*)key;

-(Cromosome*)loadCromosomeWithKey:(NSString*)key;

@property(readwrite) Cromosome * cachedCromo;
@property (nonatomic,retain)Cromosome * bestEver;
@property(readwrite) Cromosome * currentCromo;
@property(readwrite) NSString * selected_track;
@property(readwrite) NSString * nextAction;
@property(readwrite)bool garageSaveMode;


@end
