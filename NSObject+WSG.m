//
//  NSObject+WSG.m
//  WSG_KVO
//
//  Created by 王帅广 on 2017/11/28.
//  Copyright © 2017年 王帅广. All rights reserved.
//

#import "NSObject+WSG.h"
#import <objc/message.h>

@implementation NSObject (WSG)

- (void)wsg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    
    //1、自定义子类
    //2、给子类重写setName方法 调用父类的setName方法，通知观察者
    //3、修改当前对象的isa指针，指向自定义的子类
    //Person类
    NSString *oldClass = NSStringFromClass([self class]);
    //新类
    NSString *newClass = [@"wsgKVO_" stringByAppendingString:oldClass];
    //创建的子类对象
    Class myClass = objc_allocateClassPair([self class], [newClass UTF8String], 0);
    //注册类
    objc_registerClassPair(myClass);
    
    char methond[] = "setName";
    
    //给类添加setName方法
    class_addMethod(myClass, @selector(setName:), (IMP)methond, "v@:@");
    
    //修改isa指针  指向新建的子类
    object_setClass(self, myClass);
    
    //保存观察者对象
    objc_setAssociatedObject(self, @"objc", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //保存keypath
    objc_setAssociatedObject(self, @"wsgkeypath", keyPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//调用父类的setName方法 通知观察者 observer
void setName(id self,SEL _cmd,NSString *newName){
    //调用父类的set方法 变量是一个结构体 比较负责
    //objc_msgSendSuper()
    
    //改用 修改self的isa指针指向父类 调用setName方法  然后通知观察者 值发生了改变  然后再改回self的isa指针指向 子类
    id class = [self class];
    //修改self的isa指向 父类
    object_setClass(self, class_getSuperclass(class));
    //调用父类的setName方法 /* id self, SEL op, ... */ 要编译通过  要去build-setting 搜索objc_msg 设置enable为NO
    objc_msgSend(self,@selector(setName:),newName);
    
    //通知observer 值发生了改变
    id objc = objc_getAssociatedObject(self, @"objc");
    id keypath = objc_getAssociatedObject(self, @"wsgkeypath");
    objc_msgSend(objc, @selector(observeValueForKeyPath:ofObject:change:context:),self,keypath,nil,nil);
    
    //把self的isa指针改为指向子类类型
    object_setClass(self, class);
}

@end
