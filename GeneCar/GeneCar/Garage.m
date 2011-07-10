//
//  Garage.m
//  GeneCar
//
//  Created by Andrea Terzani on 08/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Garage.h"

@implementation Garage
@synthesize garage;

- (id)init
{
    self = [super init];
    if (self) {
        garage=[[NSMutableArray alloc]init];
        [self LoadGarage];
        
    }
    
    return self;
}

-(void)saveGarage{

    NSLog([NSString stringWithFormat:@"SAVE GARAGE: Garage num :%d",[garage count]]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:garage];
    
    
	[defaults setObject:myEncodedObject forKey:@"myGarage"];


}


-(void)LoadGarage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *myEncodedObject = [defaults objectForKey:@"myGarage"];
    
    self.garage=(NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    
    if(self.garage==NULL){
        garage=[[NSMutableArray alloc]init];
    }
}


@end
