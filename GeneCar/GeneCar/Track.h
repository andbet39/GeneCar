//
//  Track.h
//  GeneCar
//
//  Created by Andrea Terzani on 29/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "GeneticConfig.h"

@interface Track : NSObject
{
    b2Body* groundBody;
    
    NSString * name;
    float finishLane_x;
    float gold_time;
    float silver_time;
    float bronze_time;
    
    
    float trasf_x;
    float trasf_y;
}
@property (assign,readwrite) NSString * name ;
@property (assign,readwrite) float finishLane_x;
@property (readwrite) float gold_time;
@property (readwrite) float silver_time;
@property (readwrite) float bronze_time;

-(id)initFromPlist:(NSString *)plistFile world:(b2World *)world;
- (void) draw;
-(void)generaSavedBox : (b2World *)world;
-(void)generaFromSvg:(b2World *)world;

@end
