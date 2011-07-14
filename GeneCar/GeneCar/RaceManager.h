//
//  RaceManager.h
//  GeneCar
//
//  Created by Andrea Terzani on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "Track.h"
#import "Cromosome.h"

@interface RaceManager : NSObject
{
    float finishLane_x;
    float gold_time;
    float silver_time;
    float bronze_time;
    
    float raceTime;
    
    NSString * trackName;
    
    
    Track  * currentTrack;
    
    bool started;
    bool loaded;
    bool endded;
    

}
@property (readwrite    ) NSString * trackName;
@property (readwrite) float finishLane_x;
@property (readwrite   ) float gold_time;
@property (readwrite) float silver_time;
@property (readwrite) float bronze_time;

@property (readwrite) float raceTime;


@property (readwrite) bool started;
@property (readwrite) bool loaded;
@property (readwrite) bool ended;


-(void) loadTrackData : (Track *)track ;

@end
