//
//  GeneticLab.h
//  GeneCar
//
//  Created by Andrea Terzani on 01/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cromosome.h"
#import "GeneticConfig.h"


@interface GeneticLab : NSObject
{

    NSMutableArray * popolazione;
    NSMutableArray * toTest;
    NSMutableArray * Tested;
    
    @public int generation;

    @public int tested;
    @public BOOL avaible;
    

}

- (void) generaPopolazioneRandom;
- (Cromosome *) getNextToTest;
- (Cromosome *) getRandom;

- (void) setTested : (Cromosome *)C;
- (void) Crossover : (Cromosome*)pl1 pl2:(Cromosome*) pl2;
-(void) evolute;
-(float)fitnessmedia;

@end
