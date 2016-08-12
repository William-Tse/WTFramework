//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_ViewController.h
//  WTFramework
//

#import "WT_Precompile.h"

#import "WT_Event.h"

@interface WTViewController : UIViewController

@signal(Load)
@signal(Unload)
@signal(CreateViews)
@signal(DeleteViews)
@signal(WillAppear)
@signal(DidAppear)
@signal(WillDisappear)
@signal(DidDisappear)
@signal(MemoryWarning)

- (void)initialize;
- (void)performLayout:(BOOL)refresh;
- (void)refreshLayout;

//- (void)onSignal:(NSSignal *)name NS_REQUIRES_SUPER;

@end
