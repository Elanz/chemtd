//
//  Recipe.h
//  ChemTD
//
//  Created by Eric Lanz on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeTower : NSObject
{
    int towerType;
}

-(id) initWithTowerType:(int)newType;
-(BOOL) equalsType:(int)type;

@end


@interface Recipe : NSObject
{
    int tower1;
    int power1;
    int tower2;
    int power2;
    int tower3;
    int power3;
    int tower4;
    int power4;
    int tower5;
    int power5;
    
    int product;
    int power;
    
    NSMutableArray * towerTypesAvailable;
}

@property (nonatomic) int product;
@property (nonatomic) int power;

-(BOOL) checkCanBuildWithTower:(int)towerType power:(int)towerPower;
-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 product:(int)newproduct power:(int)newpower;
-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 tower2:(int)newtower2 power2:(int)newpower2 
             product:(int)newproduct power:(int)newpower;
-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 tower2:(int)newtower2 power2:(int)newpower2 
              tower3:(int)newtower3 power3:(int)newpower3 product:(int)newproduct 
               power:(int)newpower;
-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 tower2:(int)newtower2 power2:(int)newpower2 
              tower3:(int)newtower3 power3:(int)newpower3 tower4:(int)newtower4 power4:(int)newpower4 
             product:(int)newproduct power:(int)newpower;
-(id) initWithTower1:(int)newtower1 power1:(int)newpower1 tower2:(int)newtower2 power2:(int)newpower2 
              tower3:(int)newtower3 power3:(int)newpower3 tower4:(int)newtower4 power4:(int)newpower4 
              tower5:(int)newtower5 power5:(int)newpower5 product:(int)newproduct power:(int)newpower;
-(BOOL) canBuild:(NSMutableArray *)availableTowers;

@end