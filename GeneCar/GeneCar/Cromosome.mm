//
//  Cromosome.m
//  GeneCar
//
//  Created by Andrea Terzani on 01/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cromosome.h"

@implementation Cromosome 

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(id)initWithCromosome :(Cromosome *)C
{

    self = [super init];
    if(self){
        for(int i=0;i<VERT_NUM;i++){
            
            body_vector[i].y=C->body_vector[i].y;
            body_vector[i].x=C->body_vector[i].x;
            
        }
        
        ver_wheel0 =C->ver_wheel0;
        ver_wheel1 =C->ver_wheel1;
        
        angle_wheel0 = C->angle_wheel0;
        angle_wheel1 = C->angle_wheel1;
        
        radius_wheel0 =C->radius_wheel0;
        radius_wheel1 =C->radius_wheel1;
        
    }
    return self;

}
- (id) initRandom{

    self = [super init];
    if(self){
        for(int i=0;i<VERT_NUM;i++){
        
            body_vector[i].y=(float)(arc4random()/(RAND_MAX*2.0F)*360.0F)+0.5F;
            body_vector[i].x=(float)(arc4random()/(RAND_MAX*2.0F)*2.0F)+0.2f;
        
        }
    
        ver_wheel0 =arc4random()%VERT_NUM;
        ver_wheel1 =arc4random()%VERT_NUM;
    
        angle_wheel0 = (float)arc4random()/RAND_MAX*b2_pi;
        angle_wheel1 = (float)arc4random()/RAND_MAX*b2_pi;
        
        radius_wheel0 =(float)(arc4random()/(RAND_MAX*2.0F)*0.8F)+0.2f;        
        radius_wheel1 =(float)(arc4random()/(RAND_MAX*2.0F)*0.8F)+0.2f;

    }
    return self;
    
    
}

-(void)muta
{
    for(int i=0;i<VERT_NUM;i++){
        float mut_y=((float)rand()/(RAND_MAX)*2-1)*(body_vector[i].y*PERC_MUTAZIONE/100);
        body_vector[i].y+=mut_y;
        //NSLog([NSString stringWithFormat:@"MutazioneY:%f",mut_y ]);
        float mut_x=((float)rand()/(RAND_MAX)*2-1)*(body_vector[i].x*PERC_MUTAZIONE/100);
        body_vector[i].x+=mut_x;
        //NSLog([NSString stringWithFormat:@"MutazioneX:%f",mut_x ]);

    }
    
    angle_wheel0 +=((float)rand()/(RAND_MAX)*2-1)*(angle_wheel0*PERC_MUTAZIONE/100);
    angle_wheel1 += ((float)rand()/(RAND_MAX)*2-1)*(angle_wheel1*PERC_MUTAZIONE/100);
    
    radius_wheel0 +=((float)rand()/(RAND_MAX)*2-1)*(radius_wheel0*PERC_MUTAZIONE/100);
    radius_wheel1 +=((float)rand()/(RAND_MAX)*2-1)*(radius_wheel1*PERC_MUTAZIONE/100);
    
}
   



@end
