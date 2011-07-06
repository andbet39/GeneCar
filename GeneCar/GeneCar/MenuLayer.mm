//
//  MenuLayer.m
//  GeneCar
//
//  Created by Andrea Terzani on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "HelloWorldLayer.h"
#import "TestScene.h"
@implementation MenuLayer



+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
 	
	// return the scene
	return scene;
}

- (id)init
{
    self = [super init];
    if (self) {
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
        
        
        // Define the ground body.
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0, 0); // bottom-left corner
        
        // Call the body factory which allocates memory for the ground body
        // from a pool and creates the ground box shape (also from a pool).
        // The body is also added to the world.
        groundBody = world->CreateBody(&groundBodyDef);
        
        // Define the ground box shape.
        b2PolygonShape groundBox;		
        groundBox.SetAsEdge(b2Vec2(220/PTM_RATIO,170/PTM_RATIO), b2Vec2(470/PTM_RATIO,170/PTM_RATIO));
        
        
        b2FixtureDef groundFixtureDef;
        
        groundFixtureDef.friction=0.5f;
        groundFixtureDef.restitution=0.0f;
        groundFixtureDef.shape=&groundBox;
        
        groundBody->CreateFixture(&groundFixtureDef);
        
        groundBox.SetAsEdge(b2Vec2(220/PTM_RATIO,170/PTM_RATIO), b2Vec2(220/PTM_RATIO,300/PTM_RATIO));
        groundBody->CreateFixture(&groundFixtureDef);

        groundBox.SetAsEdge(b2Vec2(470/PTM_RATIO,170/PTM_RATIO), b2Vec2(470/PTM_RATIO,300/PTM_RATIO));
        groundBody->CreateFixture(&groundFixtureDef);
        

        myLab = [[GeneticLab alloc]init];
        
        
        mycar = [[MenuCar alloc]init];
        
        b2Vec2 init_position=b2Vec2(320.0/PTM_RATIO,350.0/PTM_RATIO);
        
        
        [mycar setInitPosition:init_position];
        
        mycar.scale=0.7;
        
        Cromosome *C=[myLab getRandom];
        GameManager * GM=[GameManager sharedGameManager];
        [GM setCurrentCromo:C];
        
        [mycar generaFromCromosome:C world:world];
        
        
        simFPSLabel=[CCLabelTTF labelWithString:@"sim FPS. : 0" fontName:@"Marker Felt" fontSize:15];
        simFPSLabel.position=ccp(290,20);
        [self addChild:simFPSLabel];
        
        
        
        CCMenuItemFont *menuItem = [CCMenuItemFont itemFromString:@"Genetic Lab" target:self selector:@selector(onGenetic:)];
		[menuItem setColor: ccc3(255,255,255)];
		[menuItem setScale:1.0];
		menuItem.position=ccp(90,100);
        
        CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"Test Lab" target:self selector:@selector(onTest:)];
		[menuItem1 setColor: ccc3(255,255,255)];
		[menuItem1 setScale:1.0];
		menuItem1.position=ccp(90,50);
        
		CCMenuItemFont *menuItem2 = [CCMenuItemFont itemFromString:@"Next" target:self selector:@selector(onRandom:)];
		[menuItem2 setColor: ccc3(255,255,255)];
		[menuItem2 setScale:1.0];
		menuItem2.position=ccp(200,200);
        
		CCMenu *menu = [CCMenu menuWithItems:menuItem ,menuItem1,menuItem2,nil];
        menu.position=ccp(0,0);
        
        [self addChild:menu];
    
        [self schedule: @selector(tick:)];

    }
    
    return self;
}

-(void) tick: (ccTime) dt
{
    int32 velocityIterations = V_ITERATION;
	int32 positionIterations = P_ITERATION;
    
    simFPS=60/dt;
    
    world->Step(dt, velocityIterations, positionIterations);
    [mycar update];
    
    
    
}

- (void)onRandom:(id)sender
{
    if(myLab->avaible){
        NSLog(@"testAnotherCar");
        
        //[myHud addListScore:mycar.cromosome->score];
        
        [myLab setTested:mycar.cromosome];
        [mycar destroy:world];
        
        mycar = [[MenuCar alloc]init];
        Cromosome *C=[myLab getRandom];
        mycar.scale=0.7;
        b2Vec2 init_position=b2Vec2(320.0/PTM_RATIO,350.0/PTM_RATIO);
        
        
        [mycar setInitPosition:init_position];
        [mycar generaFromCromosome:C world:world];
        GameManager * GM=[GameManager sharedGameManager];
        [GM setCurrentCromo:C];
        
    }
    
}
    
    - (void)onGenetic:(id)sender
    {
        
    
    
	[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];
}

- (void)onTest:(id)sender
{
    GameManager * GM=[GameManager sharedGameManager];

    [GM setCachedCromo:[GM currentCromo]];

    
	[[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[TestScene scene]]];
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
    [simFPSLabel setString:[NSString stringWithFormat:@"Gen. : %d",simFPS]];

    
	world->DrawDebugData();
    
    [mycar draw];    

	
    // restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [mycar dealloc];
    mycar=NULL;
    [myLab dealloc];
    myLab=NULL;
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
