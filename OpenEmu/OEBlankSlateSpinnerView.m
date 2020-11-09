/*
 Copyright (c) 2014, OpenEmu Team

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of the OpenEmu Team nor the
       names of its contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OEBlankSlateSpinnerView.h"
#import "OpenEmu-Swift.h"
@import QuartzCore;

@interface OEBlankSlateSpinnerView () <CALayerDelegate>
@property (strong) CALayer *spinnerLayer;
@end

@implementation OEBlankSlateSpinnerView

- (instancetype)initWithFrame:(NSRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setWantsLayer:YES];
    }
    return self;
}

- (BOOL)wantsUpdateLayer
{
    return YES;
}

- (CALayer *)makeBackingLayer
{
    CALayer *rootLayer = [CALayer layer];
    [rootLayer setDelegate:self];

    CALayer *spinnerLayer = [CALayer layer];
    [spinnerLayer setContentsGravity:kCAAlignmentCenter];
    [spinnerLayer setFrame:rootLayer.bounds];
    [spinnerLayer addAnimation:[self spinnerAnimation] forKey:nil];
    [spinnerLayer setDelegate:self];
    [self setSpinnerLayer:spinnerLayer];

    [rootLayer addSublayer:spinnerLayer];
    
    return rootLayer;
}

#pragma mark - Animation
- (CAAnimation*)spinnerAnimation
{
#define M_TAU (M_PI * 2.0)
    CAKeyframeAnimation *animation = nil;

    NSUInteger      stepCount     = 12;
    NSMutableArray *spinnerValues = [[NSMutableArray alloc] initWithCapacity:stepCount];

    for(NSUInteger step = 0; step < stepCount; step++)
        [spinnerValues addObject:@(-1*M_TAU * step / 12.0)];

    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setCalculationMode:kCAAnimationDiscrete];
    [animation setDuration:1.0];
    [animation setRepeatCount:CGFLOAT_MAX];
    [animation setRemovedOnCompletion:NO];
    [animation setValues:spinnerValues];

    return animation;
}

#pragma mark - Layer Delegate
- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if(layer == self.layer)
    {
        self.spinnerLayer.frame = layer.bounds;
        self.spinnerLayer.contents = [[NSImage imageNamed:@"blank_slate_spinner"] imageWithTintColor:[NSColor colorNamed:@"blank_slate_box_text"]];
    }
}

- (BOOL)layer:(CALayer *)layer shouldInheritContentsScale:(CGFloat)newScale fromWindow:(NSWindow *)window
{
    return YES;
}

- (id <CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    return (id <CAAction>)[NSNull null];
}
@end
