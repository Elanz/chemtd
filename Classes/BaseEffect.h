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

@interface BaseEffect : NSObject {

    int effectType;
    BaseTower * source;
    Creep * target;
    float maxDuration;
    float duration;
}

@property (nonatomic) int effectType;

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep;
- (void) startEffect;
- (void) finishEffect;
- (void) refreshEffect;
- (void) updateEffect: (double) elapsed;

@end
