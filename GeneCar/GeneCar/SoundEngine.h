//
//  SoundEngine.h
//  GeneCar
//
//  Created by Andrea Terzani on 13/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "CDAudioManager.h"
#import "SimpleAudioEngine.h"

@interface SoundEngine : NSObject
{

   
    SimpleAudioEngine *sae;

    CDSoundSource *motorSource;

    
}
-(void)playMotorSound:(float )speed;
-(void)startEngine;
@end
