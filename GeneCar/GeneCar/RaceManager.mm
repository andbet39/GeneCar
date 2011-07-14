//
//  RaceManager.m
//  GeneCar
//
//  Created by Andrea Terzani on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RaceManager.h"

@implementation RaceManager
SYNTHESIZE_SINGLETON_FOR_CLASS(RaceManager);
@synthesize finishLane_x,gold_time,silver_time,bronze_time,trackName,started,loaded,ended,raceTime;

- (id)init
{
    self = [super init];
    if (self) {
        finishLane_x=0;
        
        started=false;
        loaded=false;
        ended=false;
        
    }
    
    return self;
}

-(void) loadTrackData : (Track *)track {

     finishLane_x=track.finishLane_x;
     gold_time=track.gold_time;
     silver_time=track.silver_time;
     bronze_time=track.bronze_time;
    
     trackName= track.name;
    

}
@end
