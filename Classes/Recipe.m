//
//  Recipe.m
//  ChemTD
//
//  Created by Eric Lanz on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Recipe.h"
#import "Towers.h"
#import "GameFieldScene.h"
#import "TowerManager.h"

@implementation RecipeTower

-(id) initWithTowerType:(int)newType
{
    if ((self=[super init]))
    {
        towerType = newType;
    }
    return self;
}

-(BOOL) equalsType:(int)type
{
    if (towerType == type)
        return YES;
    return NO;
}

@end


@implementation Recipe

@synthesize product;
@synthesize power;

-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 product:(int)newproduct power:(int)newpower
{
    if ((self=[super init]))
    {
        tower1 = newtower1;
        tower2 = -1;
        tower3 = -1;
        tower4 = -1;        
        tower5 = -1;
        power1 = newpower1;
        power2 = -1;
        power3 = -1;
        power4 = -1;
        power5 = -1;
    
        product = newproduct;
        power = newpower;
    }
    return self;
}

-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 tower2:(int)newtower2 power2:(int)newpower2 
             product:(int)newproduct power:(int)newpower
{
    if ((self=[super init]))
    {
        tower1 = newtower1;
        tower2 = newtower2;
        tower3 = -1;
        tower4 = -1;
        tower5 = -1;
        power1 = newpower1;
        power2 = newpower2;
        power3 = -1;
        power4 = -1;
        power5 = -1;
        
        product = newproduct;
        power = newpower;
    }
    return self;
}

-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 tower2:(int)newtower2 power2:(int)newpower2 
              tower3:(int)newtower3 power3:(int)newpower3 product:(int)newproduct 
               power:(int)newpower
{
    if ((self=[super init]))
    {
        tower1 = newtower1;
        tower2 = newtower2;
        tower3 = newtower3;
        tower4 = -1;
        tower5 = -1;
        power1 = newpower1;
        power2 = newpower2;
        power3 = newpower3;
        power4 = -1;
        power5 = -1;
        
        product = newproduct;
        power = newpower;
    }
    return self;
}

-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 tower2:(int)newtower2 power2:(int)newpower2 
              tower3:(int)newtower3 power3:(int)newpower3 tower4:(int)newtower4 power4:(int)newpower4 
             product:(int)newproduct power:(int)newpower
{
    if ((self=[super init]))
    {
        tower1 = newtower1;
        tower2 = newtower2;
        tower3 = newtower3;
        tower4 = newtower4;
        tower5 = -1;
        power1 = newpower1;
        power2 = newpower2;
        power3 = newpower3;
        power4 = newpower4;
        power5 = -1;
        
        product = newproduct;
        power = newpower;
    }
    return self;
}

-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 tower2:(int)newtower2 power2:(int)newpower2 
              tower3:(int)newtower3 power3:(int)newpower3 tower4:(int)newtower4 power4:(int)newpower4 
              tower5:(int)newtower5 power5:(int)newpower5 product:(int)newproduct power:(int)newpower
{
    if ((self=[super init]))
    {
        tower1 = newtower1;
        tower2 = newtower2;
        tower3 = newtower3;
        tower4 = newtower4;
        tower5 = newtower5;
        power1 = newpower1;
        power2 = newpower2;
        power3 = newpower3;
        power4 = newpower4;
        power5 = newpower5;
        
        product = newproduct;
        power = newpower;
    }
    return self;
}

-(BOOL) checkCanBuildWithTower:(int)towerType power:(int)towerPower
{
    int numfound = 0;
    for (int i = 0;i<towerPower;i++)
    {
        RecipeTower * found = nil;
        for (RecipeTower * towerToTest in towerTypesAvailable)
        {
            if ([towerToTest equalsType:towerType])
            {
                found = towerToTest;            
            }
        }
        if (found)
        {
            [towerTypesAvailable removeObject:found];
            numfound++;
        }
    }
    if (numfound == towerPower)
    {
        return YES;
    }    
    return NO;
}

-(BOOL) canBuild:(NSMutableArray *)availableTowers
{    
    towerTypesAvailable = [[NSMutableArray alloc] init];
    for (BaseTower * tower in availableTowers)
    {
        //printf("considering %d\n", tower.towerType);
        for (int i = 0; i < tower.towerPower; i++)
        {
            [towerTypesAvailable addObject:[[RecipeTower alloc] initWithTowerType:tower.towerType]];
        }
    }
    BOOL tower1OK = NO;
    BOOL tower2OK = NO;
    BOOL tower3OK = NO;
    BOOL tower4OK = NO;
    BOOL tower5OK = NO;
    
    if (tower1 != -1)
    {
        tower1OK = [self checkCanBuildWithTower:tower1 power:power1];
    }
    else {
        tower1OK = YES;
    }
    if (tower2 != -1)
    {
        tower2OK = [self checkCanBuildWithTower:tower2 power:power2];
    }
    else {
        tower2OK = YES;
    }
    if (tower3 != -1)
    {
        tower3OK = [self checkCanBuildWithTower:tower3 power:power3];
    }
    else {
        tower3OK = YES;
    }
    if (tower4 != -1)
    {
        tower4OK = [self checkCanBuildWithTower:tower4 power:power4];
    }
    else {
        tower4OK = YES;
    }
    if (tower5 != -1)
    {
        tower5OK = [self checkCanBuildWithTower:tower5 power:power5];
    }
    else {
        tower5OK = YES;
    }
    if (tower1OK && tower2OK && tower3OK && tower4OK && tower5OK && [towerTypesAvailable count] == 0)
        return YES;
    else 
        return NO;
}

@end
