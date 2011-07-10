//
//  TestScene.m
//  GeneCar
//
//  Created by Andrea Terzani on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TestScene.h"
#import "MenuLayer.h"
// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
    kTagHudLayer = 2,
    
    kTagParallaxNode=1 
};

@implementation TestScene



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TestScene *layer = [TestScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    HudTestScene *myHud = [HudTestScene node];
    myHud=[[HudTestScene alloc]init];
    myHud = [HudTestScene sharedHudTestScene];
    
    [scene addChild:myHud z:1];
	
	// return the scene
	return scene;
}

- (id)init
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        
        
        
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = FALSE;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, -10.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
        //		flags += b2DebugDraw::e_jointBit;
        //		flags += b2DebugDraw::e_aabbBit;
        //		flags += b2DebugDraw::e_pairBit;
        //		flags += b2DebugDraw::e_centerOfMassBit;
        m_debugDraw->SetFlags(flags);		
        
        
        
        
		myTrack=[[Track alloc]init];
        
        //  [myTrack generaRandom:world];
        [myTrack generaSavedBox :world];
        
    
        GameManager * GM=[GameManager sharedGameManager];
        
        
        Cromosome *c=[GM cachedCromo];
        
        mycar=[[PlayableCar alloc]init];
        
        [mycar generaFromCromosome:c world:world];


        
      [self initBackground];
        
        
		[self schedule: @selector(tick:)];
        
    }
	return self;
}
-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//world->DrawDebugData();
        
    [mycar draw];
    
    [myTrack draw];
    
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}
-(void)setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    // int y = MAX(position.y, winSize.height / 2);
    int y=winSize.height/2;
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2-150, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.position = viewPoint;
    
}

-(void) tick: (ccTime) dt
{
    int32 velocityIterations = V_ITERATION;
	int32 positionIterations = P_ITERATION;
    
    HudTestScene *myHud = [HudTestScene sharedHudTestScene];
    
    if(myHud.freno_btn.active==TRUE){
        [mycar frena];
        
    }else{
        if(myHud.acceleratore_btn.active==TRUE){
    
            [mycar accelera];
        
        }
    }
    if([myHud reset]){
        [self resetCar];
    }
    if([myHud Gomain]){
        [self goMainMenu];
    }
        
        world->Step(dt, velocityIterations, positionIterations);
        [mycar update];
        b2Vec2 pos=[mycar getPosition];
        
        [self setViewpointCenter:ccp((pos.x*PTM_RATIO)-100,pos.y*PTM_RATIO)];
    
    
}

-(void) resetCar
{
    
   
    
        NSLog(@"resetCar");
        
        GameManager * GM=[GameManager sharedGameManager];
        HudTestScene *myHud = [HudTestScene sharedHudTestScene];

    
        Cromosome *c=[GM cachedCromo];

        
        [mycar destroy:world];
        
        mycar = [[PlayableCar alloc]init];
        
        [mycar generaFromCromosome:c world:world];
        [GM setCurrentCromo:c];
    [myHud setReset:FALSE];
    
        
    }
   
-(void) goMainMenu
{
    HudTestScene *myHud = [HudTestScene sharedHudTestScene];

    
    
    NSLog(@"GoMainMenu");
    [myHud setGomain:FALSE];
    
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[MenuLayer scene]]];


    
}






-(void) initBackground
{
    
    
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    
    /*CCSprite *strada = [CCSprite spriteWithFile:@"backgroundtec.png" rect:CGRectMake(0, 0, 1024*25, 512)];
    [strada.texture setTexParameters:&params];
    strada.position=ccp(240,100);
    [self addChild:strada z:-1];
    */
     
     
     CCParallaxNode *parallaxNode=[CCParallaxNode node];
     
     [self addChild:parallaxNode z:-10 tag:kTagParallaxNode];
     
     CCSprite *cielo = [CCSprite spriteWithFile:@"cielo.png" rect:CGRectMake(0, 0, 1024*5, 512)];
     [cielo.texture setTexParameters:&params];
     
     [parallaxNode addChild:cielo z:0 parallaxRatio:ccp(0.01,1.0) positionOffset:CGPointMake(512,256)];
     
     
     CCSprite *nuvole = [CCSprite spriteWithFile:@"nuvole.png" rect:CGRectMake(0, 0, 1024*5, 512)];
     [nuvole.texture setTexParameters:&params];
     nuvole.position=ccp(240,0);
     
     [parallaxNode addChild:nuvole z:1 parallaxRatio:ccp(0.05,1.0) positionOffset:CGPointMake(512,256)];
     
     
     CCSprite *montagne = [CCSprite spriteWithFile:@"montagne.png" rect:CGRectMake(0, 0, 1024*10, 512)];
     [montagne.texture setTexParameters:&params];
     
     [parallaxNode addChild:montagne z:2 parallaxRatio:ccp(0.2,1.0) positionOffset:CGPointMake(512,256)];
     
     CCSprite *alberi = [CCSprite spriteWithFile:@"alberi.png" rect:CGRectMake(0, 0, 1024*50, 512)];
     [alberi.texture setTexParameters:&params];
     alberi.position=ccp(240,0);
     
     [parallaxNode addChild:alberi z:3 parallaxRatio:ccp(0.7,1.0) positionOffset:CGPointMake(512,256)];
     
     
     CCSprite *strada = [CCSprite spriteWithFile:@"strada.png" rect:CGRectMake(0, 0, 1024*50, 512)];
     [strada.texture setTexParameters:&params];
     strada.position=ccp(240,0);
     
     [parallaxNode addChild:strada z:4 parallaxRatio:ccp(1.0,1.0) positionOffset:CGPointMake(512,256)];
     
     
     
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
