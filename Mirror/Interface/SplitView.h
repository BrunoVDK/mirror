//
//  SplitView.h
//  Mirror
//
//  Created by Bruno Vandekerkhove on 22/08/15.
//  Copyright (c) 2015 Bruno VDK. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

/**
 * The `SplitView` class represents a split view with a sidebar (supposed to be on the left) and a main view (on the right).
 *  Both views can be (un)collapsed programmatically.
 *
 *  The split view's divider thickness can also be altered.
 */
@interface SplitView : NSSplitView<NSAnimationDelegate> {
    
    BOOL animating;
    NSRect firstViewBaseFrame, secondViewBaseFrame;
    void (^completionBlock) (void);
    CGFloat _customDividerThickness;
    
}

/**
 * This split view's first subview.
 */
@property (nonatomic, readonly) NSView *firstView;

/**
 * This split view's second subview.
 */
@property (nonatomic, readonly) NSView *secondView;

/**
 * This instance's divider thickness.
 */
@property (nonatomic, readwrite) CGFloat customDividerThickness;

/**-----------------------------------------------------------------------------
 * @name (Un)collapsing views
 * -----------------------------------------------------------------------------
 */

/**
 * Collapses the given view.
 *
 * @param view The view to collapse. Should be either the sidebar of the main view of this split view.
 */
- (void)collapseView:(NSView *)view;

/**
 * Uncollapses the given view.
 *
 * @param view The view to uncollapse. Should be either the sidebar of the main view of this split view.
 */
- (void)uncollapseView:(NSView *)view;

/**
 * Collapses the given view, with or without animation.
 *
 * @param view The view to collapse. Should be either the sidebar of the main view of this split view.
 * @param flag Use this flag to enable or disable animation.
 */
- (void)collapseView:(NSView *)view withAnimation:(BOOL)flag;

/**
 * Uncollapses the given view, with or without animation.
 *
 * @param view The view to uncollapse. Should be either the sidebar of the main view of this split view.
 * @param flag Use this flag to enable or disable animation.
 */
- (void)uncollapseView:(NSView *)view withAnimation:(BOOL)flag;

/**
 * Collapses the given view (with or without animation), and runs the given block on completion.
 *
 * @param view The view to collapse. Should be either the sidebar of the main view of this split view.
 * @param flag Use this flag to enable or disable animation.
 * @param block The block to run on completion.
 */
- (void)collapseView:(NSView *)view withAnimation:(BOOL)flag completionBlock:(void(^)(void))block;

/**
 * Uncollapses the given view (with or without animation), and runs the given block on completion.
 *
 * @param view The view to uncollapse. Should be either the sidebar of the main view of this split view.
 * @param flag Use this flag to enable or disable animation.
 * @param block The block to run on completion.
 */
- (void)uncollapseView:(NSView *)view withAnimation:(BOOL)flag completionBlock:(void(^)(void))block;

/**-----------------------------------------------------------------------------
 * @name Getting split view information
 * -----------------------------------------------------------------------------
 */

/**
 * Returns the position of the divider at the given index.
 *
 * @param idx The index of the divider.
 * @return The position of the divider at the given index.
 */
- (CGFloat)positionForDividerAtIndex:(NSInteger)idx;

- (BOOL)viewIsCollapsed:(NSView *)view;

@end

/**-----------------------------------------------------------------------------
 * @name SplitView delegate protocol
 * -----------------------------------------------------------------------------
 */

/**
 * The `SplitViewDelegate` protocol provides optional methods that can be implemented by a `SplitView` delegate, so as to be notified of particular events.
 */
@protocol SplitViewDelegate <NSSplitViewDelegate>

@optional

/**
 * This method is called when a `SplitView` finished loading.
 *
 * @param splitView The `SplitView` in question.
 */
- (void)splitViewDidLoad:(SplitView *)splitView;

/**
 * This method is called when a `SplitView` finished collapsing.
 *
 * @param splitView The `SplitView` in question.
 */
- (void)splitViewDidCollapse:(SplitView *)splitView;

/**
 * This method is called when a `SplitView` finished uncollapsing.
 *
 * @param splitView The `SplitView` in question.
 */
- (void)splitViewDidUnCollapse:(SplitView *)splitView;

@end