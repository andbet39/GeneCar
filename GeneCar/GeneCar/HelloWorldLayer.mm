//
//  HelloWorldLayer.mm
//  GeneCar
//
//  Created by Andrea Terzani on 29/06/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "car.h"
#import "Cromosome.h"


//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
    kTagHudLayer = 2,
    
    kTagParallaxNode=1 
};


// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    HUDLayer * myhud = [HUDLayer node];
    myhud = [HUDLayer sharedHUDLayer];
    [scene addChild:myhud z:1];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = FALSE;
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
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
        // [myTrack generaSaved:world];
        [myTrack generaSavedBox:world];
        
        myLab = [[GeneticLab alloc]init];
        
        [myLab generaPopolazioneRandom];
     
        mycar = [[car alloc]init];
        
        
        Cromosome *C=[myLab getNextToTest];
        
        [mycar generaFromCromosome:C world:world];
        GameManager * GM=[GameManager sharedGameManager];
        [GM setCurrentCromo:C];
        
       // [self addChild:mycar];
        
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
	
	//
    
    //world->DrawDebugData();
    if (myLab->avaible){

        [mycar draw];
    }
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


-(void) testAnotherCar
{
    
    HUDLayer *myHud = [HUDLayer sharedHUDLayer];

    if(myLab->avaible){
        NSLog(@"testAnotherCar");
        //score definitivo per il cromosoma corrente
        mycar.cromosome->score=curr_car_score;
        
        //[myHud addListScore:mycar.cromosome->score];
        
        [myLab setTested:mycar.cromosome];
        [mycar destroy:world];
    
        mycar = [[car alloc]init];
        Cromosome *C=[myLab getNextToTest];
        
        [mycar generaFromCromosome:C world:world];
        GameManager * GM=[GameManager sharedGameManager];
        [GM setCurrentCromo:C];
    
    }
    tempo_ferma=0;
    curr_car_time=0;
    curr_car_score=0;
    
    //UPDATE THE HUD LAYER 
    
    [myHud setScore:curr_car_score];
    [myHud setAvgFitness:[myLab fitnessmedia]];
    [myHud setGeneration:myLab->generation];
    
    
    
     
}



-(void) tick: (ccTime) dt
{
	int32 velocityIterations = 15;
	int32 positionIterations = 1;
    
	if (myLab->avaible){
        
        world->Step(dt, velocityIterations, positionIterations);
        [mycar update];
        curr_car_time+=dt;
        b2Vec2 pos=[mycar getPosition];
    
    
    if(last_x-0.08<pos.x && last_x+0.08>pos.x){
        tempo_ferma+=dt;
        
    }else{
        tempo_ferma=0;
    }
    
    if(tempo_ferma>3.5){
        tempo_ferma=0;
        
        [self testAnotherCar];

    }
    
    if(pos.x>last_x && pos.x-10>curr_car_score){
        curr_car_score=pos.x-10;
    }
    
    if(pos.x>=200){
        tempo_ferma=0;
        [self testAnotherCar];

    }
    
    
    
    last_x=pos.x;

    
    [self setViewpointCenter:ccp((pos.x*PTM_RATIO)-100,pos.y*PTM_RATIO)];
    
    //UPDATE THE HUD LAYER 
    HUDLayer *myHud = [HUDLayer sharedHUDLayer];
    
    [myHud setScore:curr_car_score];
    
    
    }    
    
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		//[self testAnotherCar];
	}
}


-(void) initBackground
{
    
    
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    
    CCSprite *strada = [CCSprite spriteWithFile:@"backgroundtec.png" rect:CGRectMake(0, 0, 1024*25, 512)];
    [strada.texture setTexParameters:&params];
    strada.position=ccp(240,100);
    [self addChild:strada z:-1];
    
    /*
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    
    
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
    
    
    */
   
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
