//
//  SleepEffect.h
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEffect.h"
#import "cocos2d.h"

@class BaseTower;
@class Creep;

@interface EthanolEffect : BaseEffect {
    float dotElapsed;
    CCParticleSystem * NitrousSystem;
    CCRepeatForever * repeat;
}

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep;
- (void) startEffect;
- (void) finishEffect;
- (void) updateEffect: (double) elapsed;

@end
