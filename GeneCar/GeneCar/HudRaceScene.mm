//
//  HudTestScene.m
//  GeneCar
//
//  Created by Andrea Terzani on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HudRaceScene.h"
#import "SynthesizeSingleton.h"


@implementation HudRaceScene
SYNTHESIZE_SINGLETON_FOR_CLASS(HudRaceScene);

@synthesize acceleratore_btn,freno_btn,reset,Gomain,time;
- (id)init
{
    self = [super init];
    if (self) {
        
        
        
        timeLabel=[CCLabelTTF labelWithString:@"Score : 0" fontName:@"Marker Felt" fontSize:32];
        timeLabel.position=ccp(200,20);
        [self addChild:timeLabel];
        

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
		menuItem2.position=ccp(250,300);
        
        CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"MainMenu" target:self selector:@selector(onMenu:)];
		
		[menuItem1 setColor: ccc3(255,255,255)];
		[menuItem1 setScale:1.0];
		menuItem1.position=ccp(100,300);
		
		CCMenu *menu = [CCMenu menuWithItems:menuItem1 ,menuItem2,nil];
        menu.position=ccp(0,0);
        
        [self addChild:menu];
    
    }
    
    return self;
}


-(void) draw
{
    [timeLabel setString:[NSString stringWithFormat:@"Score : %f",time]];
    
}

- (void)onReset:(id)sender
{
    [self setReset:YES];   
}

- (void)onMenu:(id)sender
{
    [ self setGomain:YES];    
}
@end
