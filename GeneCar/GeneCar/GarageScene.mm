//
//  GarageScene.m
//  GeneCar
//
//  Created by Andrea Terzani on 08/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GarageScene.h"
#import "MenuCar.h"
#import "GameManager.h"
#import "MenuLayer.h"
#import "HelloWorldLayer.h"

@implementation GarageScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GarageScene *layer = [GarageScene node];
	
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
        b2FixtureDef groundFixtureDef;
        
        groundFixtureDef.friction=0.5f;
        groundFixtureDef.restitution=0.0f;
        groundFixtureDef.shape=&groundBox;
        
        mygarage=[[Garage alloc]init];
        [mygarage LoadGarage];
        
        
        menuCars=[[NSMutableArray alloc]init];
        
        //CREA LE CELLE DEL GARAGE
        int row_num=2;
        int col_num=3;
        int space=480/col_num;
        int space_v=320/row_num;
        
        for(int j=0;j<row_num;j++){
            for(int i=0;i<col_num;i++)
            {
                groundBox.SetAsEdge(b2Vec2(space*i/PTM_RATIO,j*space_v/PTM_RATIO), b2Vec2(space*(i+1)/PTM_RATIO,j*space_v/PTM_RATIO));
                groundBody->CreateFixture(&groundFixtureDef);
                
                groundBox.SetAsEdge(b2Vec2(space*i/PTM_RATIO,j*space_v/PTM_RATIO), b2Vec2(space*i/PTM_RATIO,(j+1)*space_v/PTM_RATIO));
                groundBody->CreateFixture(&groundFixtureDef);
                
                groundBox.SetAsEdge(b2Vec2(space*(i+1)/PTM_RATIO,j*space_v/PTM_RATIO), b2Vec2(space*(i+1)/PTM_RATIO,(j+1)*space_v/PTM_RATIO));
                groundBody->CreateFixture(&groundFixtureDef);
            }
        }
        //GeneticLab * myLab = [[GeneticLab alloc]init];
        
        //CREA il menu
        CCMenu *menu = [CCMenu menuWithItems:nil];
        menu.position=ccp(0,0);
        [self addChild:menu];
        
        GameManager *GM= [GameManager sharedGameManager];

        NSString *menuString;
        if([GM garageSaveMode]){
        
            menuString=@"Here";
        
        }else
        {
            menuString=@"Seelct";
        
        }
        
        int i=0;
        int j=1;
        int z=0;
        
        for(Cromosome * C in [mygarage garage]){
            
            //SCRITTA SELECT DEL MENU
            CCMenuItemFont *item = [CCMenuItemFont itemFromString:menuString target:self selector:@selector(onSelect:)];
            
            item.position=ccp((space*i)+100,(space_v*j)+100);
            [item setColor: ccc3(255,255,255)];
            [item setScale:1.0];
            
            
            
            
            //GENERA MACCHINA DEL MENU
            MenuCar *mycar = [[MenuCar alloc]init];
            
            b2Vec2 init_position=b2Vec2(((space*i)+100)/PTM_RATIO,((space_v*j)+100)/PTM_RATIO);
            
            
            [mycar setInitPosition:init_position];
            
            mycar.scale=0.7;
            
            
            [mycar generaFromCromosome:C world:world];
            
            [menuCars addObject:mycar];
            
            
            [item setUserData:C];
            
            [menu addChild:item];

            i++;
            if(i>=3){
                i=0;
                j--;
            }
            z++;
        }
        
        if(z<(col_num*row_num) && [GM garageSaveMode]){
        
            for(int y=z;y<(row_num*col_num);y++){
            
                CCMenuItemFont *item = [CCMenuItemFont itemFromString:menuString target:self selector:@selector(onSelect:)];
                
                item.position=ccp((space*i)+100,(space_v*j)+100);
                [item setColor: ccc3(255,255,255)];
                [item setScale:1.0];
            
                i++;
                if(i>=3){
                    i=0;
                    j--;
                }
                
                [menu addChild:item];

            }
                
        }
        
    }
    
    //CREA I BOTTONI PER LA SELEZIONE
    
    
    
    [self schedule: @selector(tick:)];
    
    
    return self;
}


- (void)onSelect:(CCMenuItemFont*)sender
{
    GameManager *GM= [GameManager sharedGameManager];
    
   
    if([GM garageSaveMode]){
        
        if(sender.userData!=NULL){
    
            int idx = [mygarage.garage indexOfObject:(Cromosome*) sender.userData];
        
            [mygarage.garage replaceObjectAtIndex:idx withObject:[GM currentCromo]];
        }else{
        
        
            [mygarage.garage addObject:[GM currentCromo] ];
        
        }
        
        
        
        [mygarage saveGarage];
        
        [GM setGarageSaveMode:FALSE];

        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer scene]]];

    
    }else
    
    {
    [GM setCurrentCromo:(Cromosome*) sender.userData];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[MenuLayer scene]]];
    }
    
}

-(void) tick: (ccTime) dt
{
    int32 velocityIterations = V_ITERATION;
	int32 positionIterations = P_ITERATION;
    
    
    world->Step(dt, velocityIterations, positionIterations);
    for(MenuCar *Car in menuCars){
        [Car update];
        
    }
    
    
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
    
    
	world->DrawDebugData();
    for(MenuCar *Car in menuCars){
        [Car draw];
        
    }
    // [mycar draw];    
    
	
    // restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

- (void ) LaunchLevel: (id) sender
{
	// Do Something
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
