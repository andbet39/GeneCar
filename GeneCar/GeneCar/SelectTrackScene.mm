//
//  SelectTrackScene.m
//  GeneCar
//
//  Created by Andrea Terzani on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectTrackScene.h"
#import "SlidingMenuGrid.h"
#import "GameManager.h"
#import "TestScene.h"
#import "HelloWorldLayer.h"
@implementation SelectTrackScene



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SelectTrackScene *layer = [SelectTrackScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
 	
	// return the scene
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        //LEGGE I PLIST DEI CIRCUITI
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"Track.plist"];
        
        NSDictionary* plistDictionary = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
        
        NSArray *track_lst=(NSArray*)[plistDictionary objectForKey:@"tracks_names"];
        
        
        
        
        
        
        self.anchorPoint = CGPointZero;
		self.position = CGPointZero;
		
		id target = self;
		//objc_selector* selector = @selector(LaunchLevel:);
		int iMaxLevels = [track_lst count];
		
		NSMutableArray* allItems = [NSMutableArray arrayWithCapacity:51];
        
		for (int i = 1; i <= iMaxLevels; ++i)
		{
			// create a menu item for each character
			NSString* image = [NSString stringWithFormat:@"LevelButton"];
			NSString* normalImage = [NSString stringWithFormat:@"%@.png", image];
			NSString* selectedImage = [NSString stringWithFormat:@"%@.png", image];
			
			CCSprite* normalSprite = [CCSprite spriteWithFile:normalImage];
			CCSprite* selectedSprite = [CCSprite spriteWithFile:selectedImage];
			CCMenuItemSprite* item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:target selector:@selector(LaunchLevel:)];
            
            item.userData=[track_lst objectAtIndex:i-1];
            
			[allItems addObject:item];
		}
		
		SlidingMenuGrid* menuGrid = [SlidingMenuGrid menuWithArray:allItems cols:5 rows:3 position:CGPointMake(70.f, 280.f) padding:CGPointMake(90.f, 80.f) verticalPages:false];
		[self addChild:menuGrid];
	}
	return self;
        
        
        
    }
- (void ) LaunchLevel: (id) sender
{
    NSString *track_name=(NSString*)[sender userData];
    
    GameManager *GM= [GameManager sharedGameManager];
    
    [GM setSelected_track:track_name];

    if([GM.nextAction isEqualToString:@"RACE"]){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[TestScene scene]]];
    }
    if([GM.nextAction isEqualToString:@"EVOLVI"]){
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
    }
    
    

}

@end
