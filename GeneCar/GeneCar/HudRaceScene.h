//
//  HudTestScene.h
//  GeneCar
//
//  Created by Andrea Terzani on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyButtonSkinnedBase.h"
#import "SneakyButton.h"

#import "ColoredCircleSprite.h"
@interface HudRaceScene : CCLayer
{

    SneakyButton * acceleratore_btn;
    SneakyButton * freno_btn;
    
    CCLabelTTF *timeLabel;

    bool reset;
    bool loadCar;
    
    float time;
    

}

@property(nonatomic,retain)  SneakyButton * acceleratore_btn;
@property(nonatomic,retain)  SneakyButton * freno_btn;
@property(readwrite) bool reset;
@property(readwrite) bool Gomain;
@property(assign,readwrite)float time;

@end
