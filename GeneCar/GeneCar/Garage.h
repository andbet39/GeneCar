//
//  Garage.h
//  GeneCar
//
//  Created by Andrea Terzani on 08/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Garage : NSObject
{
    NSMutableArray *garage;
}
@property(nonatomic,retain)NSMutableArray *garage;


-(void)saveGarage;
-(void)LoadGarage;


@end
