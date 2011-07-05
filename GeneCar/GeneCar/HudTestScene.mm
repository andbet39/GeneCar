//
//  HudTestScene.m
//  GeneCar
//
//  Created by Andrea Terzani on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HudTestScene.h"
#import "SynthesizeSingleton.h"


@implementation HudTestScene
SYNTHESIZE_SINGLETON_FOR_CLASS(HudTestScene);
@synthesize acceleratore_btn,freno_btn,reset;
- (id)init
{
    self = [super init];
    if (self) {
        
        
        
        scoreLabel=[CCLabelTTF labelWithString:@"Score : 0" fontName:@"Marker Felt" fontSize:15];
        scoreLabel.position=ccp(200,20);
        [self addChild:scoreLabel];
        

        SneakyButtonSkinnedBase * acceleratore= [[[SneakyButtonSkinnedBase alloc] init] autorelease];
        acceleratore.position = ccp(448,32);
        acceleratore.defaultSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 128) radius:32];
        acceleratore.activatedSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 255) radius:32];
        acceleratore.pressSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 255) radius:32];
        acceleratore.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
        acceleratore_btn = [acceleratore.button retain];
        acceleratore_btn.isToggleable = YES;
        [self addChild:acceleratore];
        
        
        SneakyButtonSkinnedBase * freno= [[[SneakyButtonSkinnedBase alloc] init] autorelease];
        freno.position = ccp(40,32);
        freno.defaultSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 128) radius:32];
        freno.activatedSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 255) radius:32];
        freno.pressSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 255) radius:32];
        freno.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
        freno_btn = [freno.button retain];
        freno_btn.isToggleable = YES;
        [self addChild:freno];   
        
        
        CCMenuItemFont *menuItem2 = [CCMenuItemFont itemFromString:@"Reset" target:self selector:@selector(onReset:)];
		
		[menuItem2 setColor: ccc3(255,255,255)];
		[menuItem2 setScale:1.0];
		menuItem2.position=ccp(0,0);
		
		CCMenu *menu = [CCMenu menuWithItems:menuItem2 ,nil];
        menu.position=ccp(400,300);
        
        [self addChild:menu];
    
    }
    
    return self;
}


- (void)onReset:(id)sender
{
    [self setReset:YES];   
}

@end
