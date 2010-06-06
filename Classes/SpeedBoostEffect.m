//
//  SpeedBoostEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpeedBoostEffect.h"
#import "BaseTower.h"

@implementation SpeedBoostEffect

- (id) initWithTargetTower:(BaseTower*)targetTower
{
    if ((self = [super initWithTargetTower:targetTower]))
    {
        
    }
    return self;
}

- (void) startEffect
{
    tower.shotInterval -= (float)tower.shotInterval * 0.15;
}

- (void) finishEffect
{
    tower.shotInterval = tower.baseInterval;
}

- (void) updateEffect: (double) elapsed
{
    
}

@end
