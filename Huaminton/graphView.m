//
//  graphView.m
//  Huaminton
//
//  Created by MengHua on 5/4/15.
//  Copyright (c) 2015 menghua.cn. All rights reserved.
//

#import "graphView.h"

@implementation graphView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    int hMax = [[self.homeHistory lastObject] intValue];
    int aMax = [[self.awayHistory lastObject] intValue];
    int haMax = hMax>aMax?hMax:aMax;
    long n = [self.homeHistory count];
    
    int height = self.frame.size.height;
    int width = self.frame.size.width;
    double xp = 0.13;
    double yp = 0.15;
    int startX = width*xp;
    int startY = height*(1-yp);
    int stepX = (width*(1-2*xp))/n;
    int stepY = (height*(1-2*yp))/haMax;
    
//    NSLog(@"height:%d,,,width:%d,,,startX:%d,,,startY:%d,,,n:%d,,,stepX:%d,,,haMax:%d,,,stepY:%d,,,",height,width,startX,startY,n,stepX,haMax,stepY);
    
    int r = 10;
    int l = 4;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor redColor] set];
    CGContextSetLineWidth(context, l);
    CGContextMoveToPoint(context, startX, startY);
    for (int i=0; i<n; i++) {
        CGContextAddLineToPoint(context, startX+i*stepX, startY-[[self.homeHistory objectAtIndex:i] doubleValue]*stepY);
        CGContextMoveToPoint(context, startX+i*stepX, startY-[[self.homeHistory objectAtIndex:i] doubleValue]*stepY);
    }
    CGContextStrokePath(context);
    
    for (int i=0; i<n; i++) {
        CGContextFillEllipseInRect(context, CGRectMake(startX+i*stepX-r/2, startY-[[self.homeHistory objectAtIndex:i] doubleValue]*stepY-r/2, r, r));
    }
    
    
    [[UIColor blueColor] set];
    CGContextSetLineWidth(context, l);
    CGContextMoveToPoint(context, startX, startY);
    for (int i=0; i<n; i++) {
        CGContextAddLineToPoint(context, startX+i*stepX, startY-[[self.awayHistory objectAtIndex:i] doubleValue]*stepY);
        CGContextMoveToPoint(context, startX+i*stepX, startY-[[self.awayHistory objectAtIndex:i] doubleValue]*stepY);
    }
    CGContextStrokePath(context);
    
    for (int i=0; i<n; i++) {
        CGContextFillEllipseInRect(context, CGRectMake(startX+i*stepX-r/2, startY-[[self.awayHistory objectAtIndex:i] doubleValue]*stepY-r/2, r, r));
    }

    int offsetFromStart=25;
    [[UIColor blackColor] set];
    CGContextSetLineWidth(context, l/2);
    
    CGContextMoveToPoint(context, startX-offsetFromStart, startY+offsetFromStart);
    CGContextAddLineToPoint(context, startX-offsetFromStart, height*yp-offsetFromStart);
    
    CGContextMoveToPoint(context, startX-offsetFromStart, startY+offsetFromStart);
    CGContextAddLineToPoint(context, width*(1-xp)+offsetFromStart, startY+offsetFromStart);
    CGContextStrokePath(context);
    
    CGContextFillEllipseInRect(context, CGRectMake(startX-offsetFromStart-r/4, startY+offsetFromStart-r/4, r/2, r/2));

    for (int i=0; i<=n; i++) {
        CGContextFillEllipseInRect(context, CGRectMake(startX+i*stepX-r/4, startY+offsetFromStart-r/4, r/2, r/2));
    }
    
    for (int i=0; i<=haMax; i++) {
        CGContextFillEllipseInRect(context, CGRectMake(startX-offsetFromStart-r/4, startY-i*stepY-r/4, r/2, r/2));
    }

}

@end
