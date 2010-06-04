//
//  PathFinding.h
//  tdtest
//
//  Created by Eric Lanz on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TILE_OPEN 0
#define TILE_FINALTOWER 128
#define TILE_GOAL 2
#define TILE_START 3
#define TILE_FINISH 4
#define TILE_MARKED 5
#define TILE_PENDINGTOWER1 6
#define TILE_PENDINGTOWER2 7
#define TILE_PENDINGTOWER3 8
#define TILE_PENDINGTOWER4 9
#define TILE_PENDINGTOWER5 10
#define TILE_BLOCKED 11


@class GameFieldScene;

@interface PathFindNode : NSObject {
@public
	int nodeX,nodeY;
	int cost;
	PathFindNode *parentNode;
}
+(id)node;
@end

@interface PathFinding : NSObject {

    GameFieldScene *gameField;
    
    NSMutableDictionary * pathCache;
    
}

- (void)resetPathCache;
- (NSMutableArray *)findPath:(int)startX :(int)startY :(int)endX :(int)endY;

@end
