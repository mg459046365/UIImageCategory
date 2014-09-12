//
//  UIImage+Custom.h
//
//  Created by ZQP on 14-7-17.
//

#import <UIKit/UIKit.h>

@interface UIImage (Custom)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)manageImage:(UIImage *)image fitSize:(CGSize)size;//得到适合屏幕的照片
+ (UIImage *)resizeImage:(UIImage *)image toHeight:(CGFloat)height;
+ (UIImage *)resizeImage:(UIImage *)image toWidth:(CGFloat)width;
+ (UIImage *)resizeImage:(UIImage*)image ToSize:(CGSize)size;
+ (UIImage *)circleImageWithColor:(UIColor*)color size:(CGSize)size;
- (UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset;

- (UIImage*)crop:(CGRect)rect;
- (UIImage*)cropWithXscale:(float)xscale Yscale:(float)yscale;//截取中间一部分 scale为宽和长所占的比例

-(UIImage*)rotateImageWithValue:(float)value;
-(UIImage*)rotateImageWithValue:(float)value xscale:(float)xScale yScale:(float)yScale;// scale为截取的比例 截取居中的一部分

@end
