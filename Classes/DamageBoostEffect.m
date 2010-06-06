//
//  DamageBoostEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DamageBoostEffect.h"
#import "BaseTower.h"

@implementation DamageBoostEffect

- (id) initWithTargetTower:(BaseTower*)targetTower
{
    if ((self = [super initWithTargetTower:targetTower]))
    {
        
    }
    return self;
}

- (void) startEffect
{
    tower.minDamage += (float)tower.minDamage * 0.15;
    tower.maxDamage += (float)tower.maxDamage * 0.15;
}

- (void) finishEffect
{
    tower.minDamage = tower.baseMinDamage;
    tower.maxDamage = tower.baseMaxDamage;
}

- (void) updateEffect: (double) elapsed
{
    
}


@end
