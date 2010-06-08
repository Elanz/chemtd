//
//  TylenolTower.h
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseTower.h"

@interface TylenolTower : BaseTower {
    NSMutableArray * targetTowers; 
    int effectRange;
}

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField;
- (void) UpdateTargets:(double)elapsed;

@end
