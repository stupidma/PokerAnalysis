//
//  MemberDelegate.h
//  PokerAnalysis
//
//  Created by He Tyrion on 12-12-2.
//  Copyright (c) 2012年 He Tyrion. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MemberDelegate <NSObject>

- (void) cancelMemberView;

- (void) selectedPlayer:(NSString *)_name playerID:(int)_id;
@end
