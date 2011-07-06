//
//  MenuCar.m
//  GeneCar
//
//  Created by Andrea Terzani on 06/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuCar.h"

@implementation MenuCar
@synthesize scale;


- (id)init
{
    self = [super init];
    if (self) {
        scale=1.0;
    }
    
    return self;
}


-(void) generaFromCromosome : (Cromosome*)c world:(b2World *) world{
    
    
    cromosome=c;
    
    b2Vec2 x;
    float v1=0;
    float v2=0;
    float r_a[VERT_NUM];
    float r_v[VERT_NUM];
    float a_tot=0;
    float a_tot2=0;
    float v_tot=0;
    float v_tot2=0;
    
    float r_f[VERT_NUM];
    float r_vf[VERT_NUM];
    
    for(int i=0;i<VERT_NUM;i++){
        
        r_a[i]=c->body_vector[i].y;
        r_v[i]=c->body_vector[i].x;
        a_tot+=r_a[i];
        v_tot+=r_v[i];
        
    }
    
    // a_tot : 2pi = r_a : x
    for(int i=0;i<VERT_NUM;i++){
        
        r_f[i]= 2*b2_pi*r_a[i]/a_tot;
        r_vf[i]= CAR_DIM *r_v[i]/v_tot;
        v_tot2+=r_vf[i];
        a_tot2+=r_f[i];
    }
    
    
    
    
    for(int i=0;i<VERT_NUM;i++){
        
        v1=r_vf[i];
        v2+=r_f[i];
        body_vectors[i]=b2Vec2(v1,v2);
        
        
    }
    
    
    
    
    float p0_X;
    float p0_Y;
    float p1_X;
    float p1_Y;
    float p2_X;
    float p2_Y;
    
    
    // Define the dynamic body.
    
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(position.x, position.y);
    
    
    body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
    
    // CARATTERISTICHE SCOCCA
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 0.8f;
	fixtureDef.friction = 5.0f;
    fixtureDef.filter.groupIndex = -1;
    
    //CREA LA SCOCCA
    
	for(int i=0;i<VERT_NUM;i++){
        
        p0_X=0.0F;
        p0_Y=0.0F;
        p1_X=(cos(body_vectors[i].y)*body_vectors[i].x)+OFFSET;
        p1_Y=(sin(body_vectors[i].y)*body_vectors[i].x)+OFFSET;
        
        if(i+1==VERT_NUM){
            p2_X=(cos(body_vectors[0].y)*body_vectors[0].x)+OFFSET;
            p2_Y=(sin(body_vectors[0].y)*body_vectors[0].x)+OFFSET;
            
        }else{
            
            p2_X=(cos(body_vectors[i+1].y)*body_vectors[i+1].x)+OFFSET;
            p2_Y=(sin(body_vectors[i+1].y)*body_vectors[i+1].x)+OFFSET;
            
        }
        b2Vec2 vert[]={
            b2Vec2(p0_X*scale,p0_Y*scale),
            b2Vec2(p1_X*scale,p1_Y*scale),
            b2Vec2(p2_X*scale,p2_Y*scale),
            
        };
        
        dynamicBox.Set(vert,3);
        
        body->CreateFixture(&fixtureDef);
        
    }
    
    
    
    //CREA IL SUPPORTO ASSI
    int rand_vert1=c->ver_wheel0;
    int rand_vert2=c->ver_wheel1;
    
    float rand_ax_ang1=c->angle_wheel0;
    float rand_ax_ang2=c->angle_wheel1;
    
    p1_X=(cos(body_vectors[rand_vert1].y)*body_vectors[rand_vert1].x)*scale+OFFSET;
    p1_Y=(sin(body_vectors[rand_vert1].y)*body_vectors[rand_vert1].x)*scale+OFFSET;
    
    dynamicBox.SetAsBox(0.2*scale, 0.15*scale, b2Vec2(p1_X,p1_Y),rand_ax_ang1 );
	body->CreateFixture(&fixtureDef);
    
    p2_X=(cos(body_vectors[rand_vert2].y)*body_vectors[rand_vert2].x)*scale+OFFSET;
    p2_Y=(sin(body_vectors[rand_vert2].y)*body_vectors[rand_vert2].x)*scale+OFFSET;
    
    dynamicBox.SetAsBox(0.2*scale, 0.15*scale, b2Vec2(p2_X,p2_Y),rand_ax_ang2 );
    fixtureDef.shape = &dynamicBox;	
    fixtureDef.filter.groupIndex = -1;
    
    body->CreateFixture(&fixtureDef);
    
    
    //CREA ASSI
    asse0=world->CreateBody(&bodyDef);
    
    dynamicBox.SetAsBox(0.3*scale, 0.1*scale, b2Vec2(p1_X-0.2*scale*cos(rand_ax_ang1)+OFFSET,p1_Y-0.2*scale*sin(rand_ax_ang1)+OFFSET),rand_ax_ang1 );
    fixtureDef.shape = &dynamicBox;	
    asse0->CreateFixture(&fixtureDef);
    
    b2PrismaticJointDef springDef;
    springDef.Initialize(body,asse0,asse0->GetWorldCenter(),b2Vec2(cos(rand_ax_ang1),sin(rand_ax_ang1)));
    springDef.lowerTranslation=-0.2*scale;
    springDef.upperTranslation=0.4*scale;
    springDef.enableLimit=true;
    springDef.enableMotor=true;
    
    spring0= (b2PrismaticJoint*) world->CreateJoint(&springDef);
    
    asse1=world->CreateBody(&bodyDef);
    
    dynamicBox.SetAsBox(0.3*scale, 0.1*scale, b2Vec2(p2_X-0.2*scale*cos(rand_ax_ang2)+OFFSET,p2_Y-0.2*scale*sin(rand_ax_ang2)+OFFSET),rand_ax_ang2 );
    fixtureDef.filter.groupIndex = -1;
    fixtureDef.shape = &dynamicBox;	
    asse1   ->CreateFixture(&fixtureDef);
    
    springDef.Initialize(body,asse1,asse1->GetWorldCenter(),b2Vec2(cos(rand_ax_ang2),sin(rand_ax_ang2)));
    
    spring1= (b2PrismaticJoint*) world->CreateJoint(&springDef);
    
    raggio0=c->radius_wheel0*scale;
    raggio1=c->radius_wheel1*scale;
    
    //CREA RUOTE
    b2CircleShape circleDef;
	circleDef.m_radius = raggio0;
	b2FixtureDef fixtureDef2;
	fixtureDef2.shape = &circleDef;
	fixtureDef2.density = 0.8f;
	fixtureDef2.friction = 4.0f;
	fixtureDef2.restitution = 0.2f;
	fixtureDef2.filter.groupIndex = -1;
    
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(asse0->GetWorldCenter().x-0.3*scale*cos(rand_ax_ang1)+OFFSET , asse0->GetWorldCenter().y-0.3*scale*sin(rand_ax_ang1)+OFFSET );
    
	bodyDef.allowSleep = false;
    fixtureDef2.shape = &circleDef;
    
	ruota0 = world->CreateBody(&bodyDef);
    ruota0->CreateFixture(&fixtureDef2);
    circleDef.m_radius = raggio1;
    
    
	bodyDef.position.Set(asse1->GetWorldCenter().x-0.3*scale*cos(rand_ax_ang2)+OFFSET, asse1->GetWorldCenter().y-0.3*scale*sin(rand_ax_ang2)+OFFSET );
    ruota1 = world->CreateBody(&bodyDef);
    ruota1->CreateFixture(&fixtureDef2);
    
    b2RevoluteJointDef revoluteJointDef;
    revoluteJointDef.enableMotor=true;
    revoluteJointDef.Initialize(asse0,ruota0,ruota0->GetWorldCenter());
    motor0=(b2RevoluteJoint *) world->CreateJoint(&revoluteJointDef);
    revoluteJointDef.Initialize(asse1,ruota1,ruota1->GetWorldCenter());
    motor1=(b2RevoluteJoint *) world->CreateJoint(&revoluteJointDef);
    
    
    
    
    
}


-(void) update{
    
    
    float body_mass=body->GetMass();
    float baseSpringForce= SPRING_BASE_FORCE*body_mass;
    
    spring0->SetMaxMotorForce( baseSpringForce + (40 * baseSpringForce * powf(spring0->GetJointTranslation(), 2) ) );
    spring0->SetMotorSpeed( -20 * spring0->GetJointTranslation() );
    
    spring1->SetMaxMotorForce( baseSpringForce + (40 * baseSpringForce * powf(spring1->GetJointTranslation(), 2) ) );
    spring1->SetMotorSpeed( -20 * spring1->GetJointTranslation());
}
/*
- (void) draw
{
    b2Vec3 c_carroz=b2Vec3(1.0,1.0,8.0);
    b2Vec3 c_ruote=b2Vec3(0.1,0.1,0.1);
    b2Vec3 c_sosp=b2Vec3(0.05,0.05,0.05);
    
    glLineWidth(1.0f);
    
    
    
    const b2Transform& xfb=body->GetTransform();
    
    for (b2Fixture* f = body->GetFixtureList(); f; f = f->GetNext())
    {
        
        b2PolygonShape* poly = (b2PolygonShape*)f->GetShape();
        int32 vertexCount = poly->m_vertexCount;
        
        b2Vec2 vertices[8];
        CGPoint v[8];
        
        for (int32 i = 0; i < vertexCount; ++i)
        {
            vertices[i] = b2Mul(xfb, poly->m_vertices[i]);
            v[i].x=vertices[i].x*PTM_RATIO*scale;
            v[i].y=vertices[i].y*PTM_RATIO*scale;
        }
        
        
        glColor4f(c_carroz.x, c_carroz.y, c_carroz.z, 0.5);
        ccDrawFillPoly(v,vertexCount,YES,YES);
        
        
        glColor4f(0.0, 0.0, 1.0, 1.0);
        //glLineWidth(3.0f);
        ccDrawPoly(v,vertexCount,YES);
        
    }
    
    //DISEGNA ASSI
    
    const b2Transform& xfa0=asse0->GetTransform();
    
    for (b2Fixture* f = asse0->GetFixtureList(); f; f = f->GetNext())
    {
        
        b2PolygonShape* poly = (b2PolygonShape*)f->GetShape();
        int32 vertexCount = poly->m_vertexCount;
        
        b2Vec2 vertices[4];
        CGPoint v[4];
        
        for (int32 i = 0; i < vertexCount; ++i)
        {
            vertices[i] = b2Mul(xfa0, poly->m_vertices[i]);
            v[i].x=vertices[i].x*PTM_RATIO*scale;
            v[i].y=vertices[i].y*PTM_RATIO*scale;
        }
        glColor4f(c_sosp.x, c_sosp.y, c_sosp.z, 0.6);
        
        ccDrawFillPoly(v,vertexCount,YES,YES);
        glColor4f(c_sosp.x, c_sosp.y, c_sosp.z, 1.0);
        
        ccDrawPoly(v,vertexCount,YES);
        
    }
    const b2Transform& xfa1=asse1->GetTransform();
    
    for (b2Fixture* f = asse1->GetFixtureList(); f; f = f->GetNext())
    {
        
        b2PolygonShape* poly = (b2PolygonShape*)f->GetShape();
        int32 vertexCount = poly->m_vertexCount;
        
        b2Vec2 vertices[4];
        CGPoint v[4];
        
        for (int32 i = 0; i < vertexCount; ++i)
        {
            vertices[i] = b2Mul(xfa1, poly->m_vertices[i]);
            v[i].x=vertices[i].x*PTM_RATIO*scale;
            v[i].y=vertices[i].y*PTM_RATIO*scale;
        }
        glColor4f(c_sosp.x, c_sosp.y, c_sosp.z, 0.6);
        
        ccDrawFillPoly(v,vertexCount,YES,YES);
        glColor4f(c_sosp.x, c_sosp.y, c_sosp.z, 1.0);
        
        //glLineWidth(2.0f);
        ccDrawPoly(v,vertexCount,YES);
        
    }
    //FIINE ASSI
    
    
    
    const b2Transform& xf = ruota0->GetTransform();
    //DISEGNA LE RUOTE
    for (b2Fixture* f = ruota0->GetFixtureList(); f; f = f->GetNext())
    {
        
        b2CircleShape* circle = (b2CircleShape*)f->GetShape();
        
        b2Vec2 center = b2Mul(xf, circle->m_p);
        float32 radius = circle->m_radius;
        b2Vec2 axis = xf.R.col1; 
        b2Vec2 destAx=center+radius*axis;
        
        glColor4f(c_ruote.x, c_ruote.y, c_ruote.z, 0.9);
        ccDrawFillCircle(ccp(center.x*PTM_RATIO*scale,center.y*PTM_RATIO*scale),radius*PTM_RATIO*scale,atan(axis.y/axis.x), 30,NO,YES);
        
        // glLineWidth(3.0f);
        glColor4f(c_ruote.x, c_ruote.y, c_ruote.z, 1.0);
        
        ccDrawLine(ccp(center.x*PTM_RATIO*scale,center.y*PTM_RATIO*scale), ccp(destAx.x*PTM_RATIO*scale,destAx.y*PTM_RATIO*scale));
        ccDrawCircle(ccp(center.x*PTM_RATIO*scale,center.y*PTM_RATIO*scale),radius*PTM_RATIO*scale,atan(axis.y/axis.x), 30,NO );
        
        
    }
    const b2Transform&  xf2 = ruota1->GetTransform();
    
    for (b2Fixture* f = ruota1->GetFixtureList(); f; f = f->GetNext())
    {
        
        b2CircleShape* circle = (b2CircleShape*)f->GetShape();
        
        b2Vec2 center = b2Mul(xf2, circle->m_p);
        float32 radius = circle->m_radius;
        b2Vec2 axis = xf2.R.col1; 
        b2Vec2 destAx=center+radius*axis;
        
        glColor4f(c_ruote.x, c_ruote.y, c_ruote.z, 0.9);
        ccDrawFillCircle(ccp(center.x*PTM_RATIO*scale,center.y*PTM_RATIO*scale),radius*PTM_RATIO*scale,atan(axis.y/axis.x), 50,NO,YES);
        
        //glLineWidth(3.0f);
        glColor4f(c_ruote.x, c_ruote.y, c_ruote.z, 1.0);
        
        ccDrawLine(ccp(center.x*PTM_RATIO*scale,center.y*PTM_RATIO*scale), ccp(destAx.x*PTM_RATIO*scale,destAx.y*PTM_RATIO*scale));
        ccDrawCircle(ccp(center.x*PTM_RATIO*scale,center.y*PTM_RATIO*scale),radius*PTM_RATIO*scale,atan(axis.y/axis.x), 50,NO );
        
    }
    
    //FINE RUOTE
    
    
    glLineWidth(1.0f);
    
}
*/


@end
