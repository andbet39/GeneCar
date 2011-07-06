//
//  GeneticLab.m
//  GeneCar
//
//  Created by Andrea Terzani on 01/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeneticLab.h"
#import "HUDLayer.h"

@implementation GeneticLab

- (id)init
{
    self = [super init];
    if (self) {
        popolazione=[[NSMutableArray alloc]init];
        toTest=[[NSMutableArray alloc]init];
        Tested=[[NSMutableArray alloc]init];
        avaible=TRUE;
        
    }
    
    return self;
}

-(void) generaPopolazioneRandom{

    for(int i=0;i<NUM_POPOLAZIONE;i++){
        Cromosome *C = [[Cromosome alloc]initRandom];  
        [toTest addObject:C];
        [popolazione addObject:C];
    }
    
}
- (Cromosome *) getRandom{
    Cromosome *C = [[Cromosome alloc]initRandom];  
    return C;
}


-(Cromosome *) getNextToTest{
    
    Cromosome *C;
    
    if(Tested.count<NUM_POPOLAZIONE){
        avaible=FALSE;
         C=(Cromosome*)[toTest lastObject];
        [toTest removeObject:C];
  
    NSLog([NSString stringWithFormat:@"getNextToTest toTest(%d):%d Tested(%d) :%d ",NUM_POPOLAZIONE-tested,toTest.count,tested,Tested.count]);
        avaible=TRUE;
        

    }else{
        avaible=FALSE;
        generation++;
        
        HUDLayer *myHud = [HUDLayer sharedHUDLayer];
        
        [myHud addListScore:[self fitnessmedia] ];
        [self evolute];
        
        C=(Cromosome*)[toTest lastObject];
        [toTest removeObject:C];

        NSLog([NSString stringWithFormat:@"getNextToTest toTest(%d):%d Tested(%d) :%d ",NUM_POPOLAZIONE-tested,toTest.count,tested,Tested.count]);
        avaible=TRUE;

    }
    
    return C;
    
}

- (void)evolute{

    
    NSMutableArray * daAccoppiare=[[NSMutableArray alloc]init];
    
    NSLog([NSString stringWithFormat:@"Inizio EVO toTest(0):%d Tested(%d) :%d ",NUM_POPOLAZIONE,toTest.count,Tested.count]);
    
    for(int i=0;i<NUM_POPOLAZIONE;i++){
        
        Cromosome *p1=[Tested objectAtIndex:i];
        [Tested removeObject:p1];
        
        int p2_index=0;
        if(Tested.count!=0){
          p2_index=arc4random()%(Tested.count);
        }
            
        Cromosome *p2=[Tested objectAtIndex:p2_index];
        
        if(p2->score>p1->score){
            [daAccoppiare addObject:p2];
            
            
        }else{
            [daAccoppiare addObject:p1];
        
        }
        [Tested insertObject:p1 atIndex:i];
            

    }
     NSLog([NSString stringWithFormat:@"Fine prima fase EVO toTest(0):%d Tested(0) :%d ",toTest.count,Tested.count]); 
    
    for(int i=0;i<NUM_POPOLAZIONE/2;i++){

    int pacc1_index=arc4random()%(daAccoppiare.count);
    Cromosome *p_Acc1=[daAccoppiare objectAtIndex:pacc1_index];
        
    int pacc2_index=arc4random()%(daAccoppiare.count);
    Cromosome *p_Acc2=[daAccoppiare objectAtIndex:pacc2_index];
    
    [self Crossover:p_Acc1 pl2:p_Acc2];
    
    
        
    
    }
    [daAccoppiare removeAllObjects];
    [Tested removeAllObjects];
    tested=0;
    
    NSLog([NSString stringWithFormat:@"Fine EVO toTest :%d Tested :%d ",toTest.count,Tested.count]);      
    
}


- (void)Crossover : (Cromosome*)pl1 pl2:(Cromosome*) pl2
{
    
    Cromosome *ch1=[[Cromosome alloc]initWithCromosome:pl1 ];
    Cromosome *ch2=[[Cromosome alloc]initWithCromosome:pl2 ];
    
    int cromo_change=arc4random()%CROSSOVER_POINT;
    NSLog([NSString stringWithFormat:@"CROMO CHANGE :%d",cromo_change]);
    
    for(int i=0;i<cromo_change;i++){
        
    int cross_index=arc4random()%(VERT_NUM+6);
        NSLog([NSString stringWithFormat:@"CROMO INDEX :%d",cross_index]);
        
    int ver_app;
    float appf;
    
    if(cross_index<VERT_NUM){
        b2Vec2 app= pl1->body_vector[cross_index];
        ch1->body_vector[cross_index]=pl2->body_vector[cross_index];
        ch2->body_vector[cross_index]=app;
    }
    else
    {
        switch (cross_index){
        case VERT_NUM:
                ver_app=pl1->ver_wheel0;
                ch1->ver_wheel0=pl2->ver_wheel0;
                ch2->ver_wheel0=ver_app;
        break;
            
        case VERT_NUM+1:            
                ver_app=pl1->ver_wheel0;
                ch1->ver_wheel0=pl2->ver_wheel0;
                ch2->ver_wheel0=ver_app;
            break;
        
                
        case VERT_NUM+2:    //RAGGIO ruota0        
                appf=pl1->radius_wheel0;
                ch1->radius_wheel0=pl2->radius_wheel0;
                ch2->radius_wheel0=appf;
                break;        
                
        case VERT_NUM+3:   //RAGGIO ruota1         
                appf=pl1->radius_wheel1;
                ch1->radius_wheel1=pl2->radius_wheel1;
                ch2->radius_wheel1=appf;
                break;       
        
            case VERT_NUM+4:   //angolo ruota1         
                appf=pl1->angle_wheel0;
                ch1->angle_wheel0=pl2->angle_wheel0;
                ch2->angle_wheel0=appf;
                break; 
            case VERT_NUM+5:   //angolo ruota1         
                appf=pl1->angle_wheel1;
                ch1->angle_wheel1=pl2->angle_wheel1;
                ch2->angle_wheel1=appf;
                break; 
                
        default:
            
            
            break;
            
    }


    }
    }    
    [ch1 muta];
    [ch2 muta];
    
    [toTest addObject:ch1];
    [toTest addObject:ch2];
}


- (void) setTested : (Cromosome *)C
{
    [Tested addObject:C];
    tested++;
}

-(float)fitnessmedia{
    int i=0;
    float fitt=0;
    for(Cromosome *C in Tested){
        i++;
        fitt+=C->score;
    }
    
    return (float)fitt/i;
    

}
                  
                  
@end
