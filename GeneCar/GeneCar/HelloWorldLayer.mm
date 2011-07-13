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
		gravity.Set(0.0f, -GRAVITY);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
        
        HUDLayer *myHud = [HUDLayer sharedHUDLayer];
        
        [myHud init];
        
        GameManager * GM=[GameManager sharedGameManager];
        
		if(GM.selected_track!=NULL){
            
            NSString * strplist=[NSString stringWithFormat:@"%@.plist",GM.selected_track];
            
            myTrack=[[Track alloc]initFromPlist:strplist world:world];
        }else
        {
            myTrack=[[Track alloc]initFromPlist:@"superJump.plist" world:world];
            
            
        }
        
        
        myLab = [[GeneticLab alloc]init];
        
        [myLab generaPopolazioneRandom];
        
        mycar = [[car alloc]init];
        best_score=0;
        tempo_ferma=0;
        curr_car_time=0;
        curr_car_score=0;
        last_x=0;
        
        Cromosome *C=[myLab getNextToTest];
        
        [mycar generaFromCromosome:C world:world];
        [GM setCurrentCromo:C];
        
        [self initBackground];
        
		[self schedule: @selector(tick:)];
        [self schedule:@selector(genUpdate:) interval:0.1];

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
        [self setViewpointCenter:ccp((pos.x*PTM_RATIO),pos.y*PTM_RATIO)];
        
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
    
    int x = MAX(position.x+100, winSize.width / 2-100);
    // int y = MAX(position.y, winSize.height / 2);
    int y=winSize.height/2;
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    
    self.position = viewPoint;
    
}


-(void) testAnotherCar
{
    
    
    if(myLab->avaible){
        
        GameManager * GM=[GameManager sharedGameManager];
        HUDLayer *myHud = [HUDLayer sharedHUDLayer];
        
        
        NSLog(@"testAnotherCar");
        //score definitivo per il cromosoma corrente
        mycar.cromosome->score=curr_car_score+(curr_car_score/curr_car_time);
        [myHud setLastScore:curr_car_score+(curr_car_score/curr_car_time)];
        
        tempo_ferma=0;
        curr_car_time=0;
        curr_car_score=0;
        last_x=0;
        
        if(mycar.cromosome->score > best_score){
            
            Cromosome *C=[[Cromosome alloc]initWithCromosome:mycar.cromosome];
            [GM setBestEver:C];
            best_score=mycar.cromosome->score;
        }
        
        [myLab setTested:mycar.cromosome];
        [mycar destroy:world];
        
        mycar = [[car alloc]init];
        Cromosome *C=[myLab getNextToTest];
        
        
        
        
        [myHud setScore:curr_car_score+(curr_car_score/curr_car_time)];
        [myHud setAvgFitness:[myLab fitnessmedia]];
        [myHud setGeneration:myLab->generation];
        
        [mycar generaFromCromosome:C world:world];
        
        [GM setCurrentCromo:C];
        
        
        
        
    }
    
    
}

-(void) genUpdate: (ccTime) dt
{

	
    
	if (myLab->avaible){
        
        
        
        
        if(pos.x>last_x && pos.x-10>curr_car_score){
            curr_car_score=pos.x-10;
            
        }
        
        
        if(pos.x>=205){
            tempo_ferma=0;
            
            [self testAnotherCar];
            
        }
        
        
        if(last_x-STOP_LIMIT<pos.x && last_x+STOP_LIMIT>pos.x){
            tempo_ferma+=dt;
            
        }else{
            tempo_ferma=0;
        }
        
        if(tempo_ferma>3.0){
            tempo_ferma=0;
            
            [self testAnotherCar];
            
        }
        
        last_x=pos.x;
        
     //UPDATE THE HUD LAYER 
        HUDLayer *myHud = [HUDLayer sharedHUDLayer];
        
        [myHud setScore:curr_car_score+(curr_car_score/curr_car_time)];
        
        
    } 

}

-(void) tick: (ccTime) dt
{
   
    curr_car_time+=dt;
    world->Step(dt*TIME_MULTIPLIER, V_ITERATION, P_ITERATION);
    [mycar update];
    pos=[mycar getPosition];

}



-(void) initBackground
{
    
    
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    
    CCSprite *strada = [CCSprite spriteWithFile:@"backgroundtec.png" rect:CGRectMake(0, 0, 1024*25, 512)];
    [strada.texture setTexParameters:&params];
    strada.position=ccp(240,100);
    [self addChild:strada z:-1];
    
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
