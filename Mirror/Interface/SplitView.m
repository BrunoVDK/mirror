//
//  NSSplitView+Animation.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 22/08/15.
//  Copyright (c) 2015 Bruno VDK. All rights reserved.
//

#import "SplitView.h"

#pragma mark Split View

@interface SplitView(Private)

- (void)didResize;

@end

@implementation SplitView

@synthesize customDividerThickness = _customDividerThickness;

#pragma mark Interface

- (void)awakeFromNib {
    
    [self setCustomDividerThickness:1.0];
    
    firstViewBaseFrame = self.firstView.frame;
    secondViewBaseFrame = self.secondView.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didResize) name:NSSplitViewDidResizeSubviewsNotification object:self];
    
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(splitViewDidLoad:)])
        [(id<SplitViewDelegate>)[self delegate] splitViewDidLoad:self];
    
}

- (void)didResize {
    
    [self adjustSubviews];
    
}

#pragma mark Getters

- (NSView *)firstView {
    
    return ([self.subviews count] == 2 ? [self.subviews firstObject] : nil);
    
}

- (NSView *)secondView {
    
    return ([self.subviews count] == 2 ? [self.subviews objectAtIndex:1] : nil);
    
}

- (CGFloat)positionForDividerAtIndex:(NSInteger)idx {
    
    if ([[self subviews] count] <= idx)
        return 0.0;
    
    NSRect frame = [[[self subviews] objectAtIndex:idx] frame];
    return (self.isVertical ? NSMaxX(frame) + ([self dividerThickness] * idx) : NSMaxY(frame) + ([self dividerThickness] * idx));
    
}

- (CGFloat)dividerThickness {
    
    return [self customDividerThickness];
    
}

- (BOOL)viewIsCollapsed:(NSView *)view {
    
    return [self isSubviewCollapsed:view];
    
}

#pragma mark (Un)collapsing

/*
 http://stackoverflow.com/questions/6315091/how-to-expand-and-collapse-nssplitview-subviews-with-animation
 */

- (void)collapseView:(NSView *)view {
    
    [self collapseView:view withAnimation:true];
    
}

- (void)collapseView:(NSView *)view withAnimation:(BOOL)flag {
    
    [self collapseView:view withAnimation:flag completionBlock:nil];
    
}

- (void)collapseView:(NSView *)view withAnimation:(BOOL)flag completionBlock:(void(^)(void))block {
    
    if ((flag && animating) || (view != self.firstView && view != self.secondView))
        return;
    
    animating = true;
    
    if (flag)
        completionBlock = Block_copy(block);
    
    NSView *mainView = (view == self.firstView ? self.secondView : self.firstView);
    NSView *collapsingView = view;
    
    NSRect mainFrame = mainView.frame;
    NSRect collapsingFrame = collapsingView.frame;
    
    if (self.isVertical) {
        mainFrame.size.width =  self.frame.size.width;
        mainFrame.origin.x =  0.0f;
        collapsingFrame.size.width = 0.0f;
    }
    else {
        mainFrame.size.height =  self.frame.size.height;
        mainFrame.origin.y =  0.0f;
        collapsingFrame.size.height = 0.0f;
    }
    
    if (!flag) {
        
        [mainView setFrame:mainFrame];
        [collapsingView setFrame:collapsingFrame];
        
        [view setHidden:true]; // Otherwise the subview is not considered collapsed
        
        [self didResize];
        
        animating = false;
        
        return;
        
    }
    
    NSMutableDictionary *mainAnimationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [mainAnimationDict setObject:mainView forKey:NSViewAnimationTargetKey];
    [mainAnimationDict setObject:[NSValue valueWithRect:mainFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSMutableDictionary *collapsingAnimationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [collapsingAnimationDict setObject:collapsingView forKey:NSViewAnimationTargetKey];
    [collapsingAnimationDict setObject:[NSValue valueWithRect:collapsingFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSViewAnimation *collapseAnimation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:mainAnimationDict, collapsingAnimationDict, nil]];
    [collapseAnimation setDuration:0.25f];
    [collapseAnimation startAnimation];
    [collapseAnimation setDelegate:self];
    [collapseAnimation release];
    
}

- (void)uncollapseView:(NSView *)view {
    
    [self uncollapseView:view withAnimation:true];
    
}

- (void)uncollapseView:(NSView *)view withAnimation:(BOOL)flag {
    
    [self uncollapseView:view withAnimation:true completionBlock:nil];
    
}

- (void)uncollapseView:(NSView *)view withAnimation:(BOOL)flag completionBlock:(void(^)(void))block {
    
    if (flag && animating)
        return;
    
    if (view == self.firstView && [self viewIsCollapsed:view])
        [self.firstView setHidden:false];
    else if (view == self.secondView && [self viewIsCollapsed:view])
        [self.secondView setHidden:false];
    else
        return;
    
    animating = true;
    
    if (flag)
        completionBlock = Block_copy(block);

    NSView *mainView, *uncollapsingView;
    mainView = (view == self.firstView ? self.secondView : self.firstView);
    uncollapsingView = view;
    
    NSRect mainFrame = mainView.frame;
    NSRect uncollapsingFrame = (view == self.firstView ? firstViewBaseFrame : secondViewBaseFrame);
    
    if (self.isVertical) {
        mainFrame.size.width =  self.frame.size.width - uncollapsingFrame.size.width;
        mainFrame.origin.x =  uncollapsingFrame.size.width - uncollapsingFrame.origin.x;
    }
    else {
        mainFrame.size.height =  self.frame.size.height - uncollapsingFrame.size.height;
        mainFrame.origin.y =  uncollapsingFrame.size.height - uncollapsingFrame.origin.y;
    }
    
    if (!flag) {
        
        [mainView setFrame:mainFrame];
        [uncollapsingView setFrame:uncollapsingFrame];
        
        [self didResize];
        
        animating = false;
        
        return;
        
    }
    
    NSMutableDictionary *mainAnimationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [mainAnimationDict setObject:mainView forKey:NSViewAnimationTargetKey];
    [mainAnimationDict setObject:[NSValue valueWithRect:mainFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSMutableDictionary *uncollapsingAnimationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [uncollapsingAnimationDict setObject:uncollapsingView forKey:NSViewAnimationTargetKey];
    [uncollapsingAnimationDict setObject:[NSValue valueWithRect:uncollapsingFrame] forKey:NSViewAnimationEndFrameKey];
    
    NSViewAnimation *uncollapseAnimation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObjects:mainAnimationDict, uncollapsingAnimationDict, nil]];
    [uncollapseAnimation setDuration:0.25f];
    [uncollapseAnimation startAnimation];
    [uncollapseAnimation setDelegate:self];
    [uncollapseAnimation release];
    
}

#pragma mark - Animation Delegate

- (void)animationDidStart:(CAAnimation *)anim {
    
    
    
}

- (void)animationDidEnd:(NSAnimation *)animation {
    
    if ([self viewIsCollapsed:self.firstView]) {
        
        [self collapseView:self.firstView withAnimation:false];
        
        if ([self delegate] && [[self delegate] respondsToSelector:@selector(splitViewDidCollapse:)])
            [(id<SplitViewDelegate>)[self delegate] splitViewDidCollapse:self];
        
    }
    else if ([self viewIsCollapsed:self.secondView]) {
        
        [self collapseView:self.secondView withAnimation:false];
        
        if ([self delegate] && [[self delegate] respondsToSelector:@selector(splitViewDidCollapse:)])
            [(id<SplitViewDelegate>)[self delegate] splitViewDidCollapse:self];
        
    }
    else {
        
        if ([self delegate] && [[self delegate] respondsToSelector:@selector(splitViewDidUnCollapse:)])
            [(id<SplitViewDelegate>)[self delegate] splitViewDidUnCollapse:self];
        
    }
    
    if (completionBlock) {
        completionBlock();
        Block_release(completionBlock);
    }
    
    animating = false;
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    Block_release(completionBlock);
    
    [super dealloc];
    
}

@end
