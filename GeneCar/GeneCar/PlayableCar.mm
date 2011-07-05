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
        // Initialization code here.
    }
    
    return self;
}

-(void) update{


    float body_mass=body->GetMass();
    float baseSpringForce=15*body_mass;
    
    spring0->SetMaxMotorForce( baseSpringForce + (40 * baseSpringForce * powf(spring0->GetJointTranslation(), 2) ) );
    spring0->SetMotorSpeed( -20 * spring0->GetJointTranslation() );
    
    spring1->SetMaxMotorForce( baseSpringForce + (40 * baseSpringForce * powf(spring1->GetJointTranslation(), 2) ) );
    spring1->SetMotorSpeed( -20 * spring1->GetJointTranslation());
    
    

}

-(void) accelera
{
    
    float body_mass=body->GetMass();

    float torque0= 1+(body->GetMass()*4)/raggio0;
    float speed0=raggio0*7*b2_pi;
    
    motors_speed-=raggio0*0.005*b2_pi;
    motor0->SetMotorSpeed(motors_speed);
    motor0->SetMaxMotorTorque(torque0);
    
    float torque1= 1+(body_mass*4)/raggio0;
    float speed1=raggio1*7*b2_pi;
    
    motor1->SetMotorSpeed(motors_speed);
    motor1->SetMaxMotorTorque(torque1);
    motors_speed=motor0->GetMotorSpeed();

}

-(void) frena
{
    
    float body_mass=body->GetMass();
    float speed=0;
    
    float torque0= 1+(body->GetMass()*8)/raggio0;
    float speed0=raggio0*6*b2_pi;
    motors_speed-=motor0->GetMotorSpeed()*0.02;
    
    if(motors_speed<0.01)
    {
        speed=raggio1*2*b2_pi;
    }else
    {
        speed=motor0->GetMotorSpeed()*0.02;
    }
    motor0->SetMotorSpeed(speed);
    motor0->SetMaxMotorTorque(torque0);
    
    float torque1= 1+(body_mass*4)/raggio0;
    float speed1=raggio1*6*b2_pi;
    
    motor1->SetMotorSpeed(speed);
    motor1->SetMaxMotorTorque(torque1);
    
}

@end
