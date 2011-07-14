//
//  SoundEngine.m
//  GeneCar
//
//  Created by Andrea Terzani on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundEngine.h"

///////////////////////////////////////////////////////
//Sound ids, these equate to buffer identifiers
//which are 0 indexed and sequential.  You do not have
//to use all the identifiers but an exception will be
//thrown if you specify an identifier that is greater 
//than or equal to the total number of buffers
#define SND_ID_MOTORLOOP 0

//Channel group ids, the channel groups define how voices
//will be shared.  If you wish you can simply have a single
//channel group and all sounds will share all the voices
#define CGROUP_MOTORLOOP 0



@implementation SoundEngine

- (id)init
{
    self = [super init];
    if (self) {
        [[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
        sae=[[SimpleAudioEngine alloc]init];
    }
    
    return self;
}

-(void)startEngine
{
    motorSource =[[CDSoundSource alloc]init];
    motorSource = [[sae soundSourceForFile:@"motor1.mp3"] retain];
    motorSource.looping=YES;
    motorSource.gain=1.0f;
    NSLog([NSString stringWithFormat: @"Sound 1 duration %0.4f",motorSource.durationInSeconds ]);
    [motorSource play];
    
}

-(void)playMotorSound:(float )speed{

    //NSLog([NSString stringWithFormat: @"speed = %f",speed]);

    motorSource.pitch=0.3+speed;
   
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
    
    [motorSource release];
    
    [sae release];
    [SimpleAudioEngine end];

	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
