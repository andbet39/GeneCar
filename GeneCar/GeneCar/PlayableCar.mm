//
//  PlayableCar.m
//  GeneCar
//
//  Created by Andrea Terzani on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayableCar.h"


@implementation PlayableCar

- (id)init
{
    self = [super init];
    if (self) {
        se=[[SoundEngine alloc]init];
        [se startEngine];
    }
    
    return self;
}

-(void) update{


    float body_mass=body->GetMass();
    float baseSpringForce= SPRING_BASE_FORCE*body_mass;
    
    spring0->SetMaxMotorForce( baseSpringForce + (40 * baseSpringForce * powf(spring0->GetJointTranslation(), 2) ) );
    spring0->SetMotorSpeed( -20 * spring0->GetJointTranslation() );
    
    spring1->SetMaxMotorForce( baseSpringForce + (40 * baseSpringForce * powf(spring1->GetJointTranslation(), 2) ) );
    spring1->SetMotorSpeed( -20 * spring1->GetJointTranslation());
    
    
    motor0->SetMotorSpeed(0);
    motor0->SetMaxMotorTorque( 0.5);
    motor1->SetMotorSpeed(0);
    motor1->SetMaxMotorTorque( 0.5);
    
        [se playMotorSound:[self getSpeed]*0.05 ];
    
}

-(void) accelera
{

    motor0->SetMotorSpeed(-15*b2_pi*raggio0);
    motor0->SetMaxMotorTorque(30);
    
    motor1->SetMotorSpeed(-15*b2_pi*raggio1);
    motor1->SetMaxMotorTorque(30);


}

-(float)getSpeed{
    
    return fabsf( ruota0->GetAngularVelocity());
    

}

-(void) frena
{
    motor0->SetMotorSpeed(8*raggio0*b2_pi);
    motor0->SetMaxMotorTorque(27);
    
    motor1->SetMotorSpeed(8*raggio1*b2_pi);
    motor1->SetMaxMotorTorque(27);

}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
    
	[se dealloc];
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
