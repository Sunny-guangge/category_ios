//
//  NSObject+WSG.h
//  WSG_KVO
//
//  Created by 王帅广 on 2017/11/28.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WSG)

//自定义观察方法
- (void)wsg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;

@end
