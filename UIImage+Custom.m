//
//  UIImage+Custom.m
//
//  Created by ZQP on 14-7-17.
//

#import "UIImage+Custom.h"

#import "Utility.h"

@implementation UIImage (Custom)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)manageImage:(UIImage *)image fitSize:(CGSize)size{//得到适合屏幕的照片
 
//    float imageViewHeight=SCREENVIEW_HEIGHT-44-90-8;
//    float imageViewWidth= SCREEN_WIDTH-12;
    
    float imageViewHeight=size.height;
    float imageViewWidth=size.width;
    
    LFNSlogWidthHeight(image.size.width, image.size.height);
    
    return (image.size.width/image.size.height > imageViewWidth/imageViewHeight) ? [self resizeImage:image toWidth:imageViewWidth] : [self resizeImage:image toHeight:imageViewHeight];

}

+ (UIImage *)resizeImage:(UIImage *)image toHeight:(CGFloat)height {
    CGRect rect = CGRectMake(0, 0, image.size.width * height / image.size.height, height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [image drawInRect:rect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return resultImage;
}

+ (UIImage *)resizeImage:(UIImage *)image toWidth:(CGFloat)width {
    CGRect rect = CGRectMake(0, 0, width, image.size.height * width / image.size.width);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [image drawInRect:rect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return resultImage;
}
+ (UIImage *)resizeImage:(UIImage*)image ToSize:(CGSize)size{
    CGRect rect={0,0,size};
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:rect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return resultImage;

    
    
}
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
+ (UIImage *)circleImageWithColor:(UIColor*)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2);
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}
- (UIImage*)crop:(CGRect)rect//裁剪
{
    if (rect.size.height==self.size.height&&rect.size.width==self.size.width) {
        return self;
    }
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rect.size.width, rect.size.height), NO, 0.0);
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
- (UIImage*)cropWithXscale:(float)xscale Yscale:(float)yscale{//截取中间一部分 宽和长所占的比例
    if (xscale==1&&yscale==1) {
        return self;
    }
    
    CGSize size=self.size;
    float originX=size.width*(1-xscale)/2;
    float originy=size.height*(1-yscale)/2;
    float width=size.width*xscale;
    float height=size.height*yscale;
    
    UIImage *img = nil;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    [self drawAtPoint:CGPointMake(-originX, -originy)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return img;

    
}
-(UIImage*)rotateImageWithValue:(float)value{
    UIImage *image=[self buildImage:self xScale:1 yScale:1 withValue:value];
    return image;
}
-(UIImage*)rotateImageWithValue:(float)value xscale:(float)xScale yScale:(float)yScale{
    if (value==0) {
        return self;
    }
    UIImage *image=[self buildImage:self xScale:xScale yScale:yScale withValue:value];
    return image;

}

- (UIImage*)buildImage:(UIImage*)image xScale:(float)xScale yScale:(float)yScale withValue:(float)value
{
    switch (self.imageOrientation) {
        case UIImageOrientationRight:
            value+=0.5;
            break;
        case UIImageOrientationLeft:
            value-=0.5;
            break;
        case UIImageOrientationDown:
            value+=1;
            break;
        default:
            break;
    }
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIAffineTransform" keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //NSLog(@"%@", [filter attributes]);
    
    [filter setDefaults];
    CGAffineTransform transform = CATransform3DGetAffineTransform([self rotateTransform:CATransform3DIdentity clockwise:NO rotateValue:value]);
    [filter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    result=[result cropWithXscale:(xScale) Yscale:(yScale)];
    
    return result;
}
- (CATransform3D)rotateTransform:(CATransform3D)initialTransform clockwise:(BOOL)clockwise rotateValue:(float)value
{
    CGFloat arg = (value)*M_PI;
    if(!clockwise){
        arg *= -1;
    }
    
    CATransform3D transform = initialTransform;
    transform = CATransform3DRotate(transform, arg, 0, 0, 1);
    transform = CATransform3DRotate(transform, 0*M_PI, 0, 1, 0);
    transform = CATransform3DRotate(transform, 0*M_PI, 1, 0, 0);
    
    return transform;
}

//if (size.width>size.height) {
//    image=[UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.alasset.thumbnail, CGRectMake((size.width-48/66*size.width)/2,0, 48/66*size.width, size.height))];
//}else{
//    image=[UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.alasset.thumbnail, CGRectMake(0, (size.height-66/48*size.width)/2, size.width, 66/48*size.width))];
//}

@end
