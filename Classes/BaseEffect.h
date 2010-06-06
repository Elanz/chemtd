//
//  BaseEffect.h
//  ChemTD
//
//  Created by Eric Lanz on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseTower;
@class Creep;
@class GameFieldScene;

#define CreepTarget 0
#define FieldTarget 1

@interface BaseEffect : NSObject {

    int effectType;
    BaseTower * source;
    Creep * creep;
    GameFieldScene * field;
    CGPoint position;
    int targetType;
    float maxDuration;
    float duration;
}

@property (nonatomic) int effectType;

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep;
- (id) initWithSourceField:(BaseTower*)sourceTower target:(GameFieldScene*)targetField position:(CGPoint)targetPosition;
- (void) startEffect;
- (void) finishEffect;
- (void) refreshEffect;
- (void) updateEffect: (double) elapsed;

@end
