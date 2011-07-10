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
@synthesize cachedCromo,currentCromo,garageSaveMode;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



-(void)saveCromosome:(Cromosome*)obj key:(NSString *)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
    
    
	[defaults setObject:myEncodedObject forKey:key];
}

-(Cromosome*)loadCromosomeWithKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *myEncodedObject = [defaults objectForKey: key];
    Cromosome* obj = (Cromosome*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}
@end
