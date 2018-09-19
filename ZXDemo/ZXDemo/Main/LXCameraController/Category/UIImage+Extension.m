//
//  UIImage+Extension.m
//  LiangFengYouXin
//
//  Created by 周峻觉 on 16/6/2.
//  Copyright © 2016年 周峻觉. All rights reserved.
//

#import "UIImage+Extension.h"
#include <CoreText/CoreText.h>
#include <CoreGraphics/CoreGraphics.h>
//#import "LXImageCache.h"

@implementation UIImage (Extension)

- (CGSize)scaleSizeWithNewHeight:(CGFloat)newHeight
{
    CGFloat scale = self.size.height/self.size.width;
    CGFloat imageWidth = newHeight / scale;
    return CGSizeMake(imageWidth, newHeight);
}

- (CGSize)scaleSizeWithNewWidth:(CGFloat)newWidth
{
    CGFloat scale = self.size.height/self.size.width;
    CGFloat imageHeight = newWidth * scale;
    return CGSizeMake(newWidth, imageHeight);
}

//使用新的宽度等比例缩放图片
+ (nullable UIImage *)imageWithImage:(nonnull UIImage *)image height:(CGFloat)height
{
    if (!image) {
        return nil;
    }
    CGFloat scale = image.size.height/image.size.width;
    CGFloat width = height / scale;
    
    //获得画布大小
    UIGraphicsBeginImageContextWithOptions (CGSizeMake(width, height), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    
    //返回绘制的新图形
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

//使用新的宽度等比例缩放图片
+ (nullable UIImage *)imageWithImage:(nonnull UIImage *)image width:(CGFloat)width
{
    if (!image) {
        return nil;
    }
    CGFloat scale = image.size.height/image.size.width;
    CGFloat height = width * scale;
    
    //获得画布大小
    UIGraphicsBeginImageContextWithOptions (CGSizeMake(width, height), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    
    //返回绘制的新图形
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 裁剪出最大的方形image
+ (UIImage*)squareImageWithImage:(UIImage *)image
{
    if (image == nil) {
        return nil;
    }
    UIImage *squareImage = nil;
    CGSize imageSize = [image size];
    
    if (imageSize.width == imageSize.height)
    {
        squareImage = image;
    }
    else
    {
        // Compute square crop rect
        CGFloat smallerDimension = MIN(imageSize.width, imageSize.height);
        CGRect cropRect = CGRectMake(0, 0, smallerDimension, smallerDimension);
        
        // Center the crop rect either vertically or horizontally, depending on which dimension is smaller
        if (imageSize.width <= imageSize.height)
        {
            cropRect.origin = CGPointMake(0, rintf((imageSize.height - smallerDimension) / 2.0));
        }
        else
        {
            cropRect.origin = CGPointMake(rintf((imageSize.width - smallerDimension) / 2.0), 0);
        }
        
        CGImageRef croppedImageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        squareImage = [UIImage imageWithCGImage:croppedImageRef];
        CGImageRelease(croppedImageRef);
    }
    
    return squareImage;
}

+ (UIImage *)clipedImageWithImage:(UIImage *)image path:(UIBezierPath *)path
{ 
    if (image == nil) {
        return nil;
    }else if (path == nil){
        return image;
    }
    
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    // 设置裁剪区域
    [path addClip];
    // 绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 获取当前图片
    UIImage *clipedimage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    UIImage* clipedImg = [UIImage clipedImageWithImage:clipedimage rect:path.bounds];
    return clipedImg;
}

//裁剪image
// 图片裁剪时，以px（像素）计算，不以pt(点)计算
+ (UIImage *)clipedImageWithImage:(UIImage *)image rect:(CGRect)rect{
    if (!image) {
        return nil;
    }
    
    CGRect sRect = CGRectMake(rect.origin.x*image.scale, rect.origin.y*image.scale, rect.size.width*image.scale, rect.size.height*image.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, sRect);
    UIGraphicsBeginImageContext(sRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, sRect, imageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    UIImage* sImage = [UIImage scaledImage:smallImage size:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*(smallImage.size.height/smallImage.size.width))];
    return sImage;
}

//压缩image
//size:新的size
+ (UIImage *)scaledImage:(UIImage *)image size:(CGSize)size
{
    if (!image) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//+ (nullable UIImage *)imageWithImage:(nonnull UIImage *)image text:(nullable NSString *)text textAttribute:(nullable  LXTextAttribute*)attr textOrigin:(CGPoint)origin
//{
//    CGSize size = [attr rootSize];
//
//    //获得画布大小
//    UIGraphicsBeginImageContextWithOptions (size, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//
//    if(text)
//    {
//        // 获得一个位图图形上下文
//        CGContextRef context= UIGraphicsGetCurrentContext ();
//        CGContextDrawPath (context, kCGPathStroke);
//
//        UIFont * font = [attr textFont];
//        UIColor* color = [attr textColor];
//        NSInteger space = attr.textWordSpace;
//
//        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
//        [dic setValue:font forKey:NSFontAttributeName];
//        [dic setValue:color forKey:NSForegroundColorAttributeName];
//        [dic setValue:@(space) forKey:NSKernAttributeName];
//
//        [text drawAtPoint:origin withAttributes:dic];
//
//    }
//
//    //返回绘制的新图形
//    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    //关闭上下文
//    UIGraphicsEndImageContext();
//
//    return newImage;
//}

//+ (nullable UIImage *)imageWithImage:(nonnull UIImage *)image textAttributes:(NSArray<LXTextAttribute*>*)attrs
//{
//    if (!attrs || attrs.count == 0) {
//        return nil;
//    }
//
//    CGSize size = attrs[0].rootSize;
//
//    //获得画布大小
//    UIGraphicsBeginImageContextWithOptions (size, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//
//    // 获得一个位图图形上下文
//    CGContextRef context= UIGraphicsGetCurrentContext ();
//    CGContextDrawPath (context, kCGPathStroke);
//    for (LXTextAttribute* attr in attrs) {
//        NSString* text = attr.text;
//        CGPoint origin = attr.textOrigin;
//        UIFont * font = [attr textFont];
//        UIColor* color = [attr textColor];
//        NSInteger space = attr.textWordSpace;
//
//        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
//        [dic setValue:font forKey:NSFontAttributeName];
//        [dic setValue:color forKey:NSForegroundColorAttributeName];
//        [dic setValue:@(space) forKey:NSKernAttributeName];
//
//        [text drawAtPoint:origin withAttributes:dic];
//    }
//
//    //返回绘制的新图形
//    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    //关闭上下文
//    UIGraphicsEndImageContext();
//
//    return newImage;
//}

//+ (nullable UIImage *)imageWithImage:(nonnull UIImage *)image textAttributes:(NSArray<LXTextAttribute*>*)textAttrs pictureAttributes:(NSArray<LXPictureAttribute *> *)picAttrs
//{
//    CGSize size = CGSizeZero;
//
//    if(textAttrs && textAttrs.count > 0){
//        size = textAttrs[0].rootSize;
//    }else if (picAttrs && picAttrs.count > 0){
//        size = picAttrs[0].rootSize;
//    }else{
//        return nil;
//    }
//
//    // 获得一个位图图形上下文
//    UIGraphicsBeginImageContextWithOptions (size, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    CGContextRef context= UIGraphicsGetCurrentContext();
//    if (context == nil) {
//        return nil;
//    }
//    CGContextDrawPath (context, kCGPathStroke);
//
//    if (textAttrs && textAttrs.count > 0) {
//        for (LXTextAttribute* attr in textAttrs) {
//            NSString* text = attr.text;
//            CGPoint origin = attr.textOrigin;
//            UIFont * font = [attr textFont];
//            UIColor* color = [attr textColor];
//            NSInteger space = attr.textWordSpace;
//
//            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
//            [dic setValue:font forKey:NSFontAttributeName];
//            [dic setValue:color forKey:NSForegroundColorAttributeName];
//            [dic setValue:@(space) forKey:NSKernAttributeName];
//
//            [text drawAtPoint:origin withAttributes:dic];
//        }
//    }
//    if (picAttrs && picAttrs.count > 0) {
//        UIImage* im = nil;
//        for (LXPictureAttribute* attr in picAttrs) {
//            NSString* path = attr.picturePath;
//            if ([path hasPrefix:@"http"]) {
//                im = [[LXImageCache shared] imageForKey:path];
//            }else{
//                im = [UIImage imageWithContentsOfFile:path];
//            }
//            if (im) {
//                [im drawInRect:CGRectMake(attr.pictureOriginX, attr.pictureOriginY, attr.pictureWidth, attr.pictureHeight)];
//            }
//        }
//    }
//
//    //返回绘制的新图形
//    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//    //关闭上下文
//    UIGraphicsEndImageContext();
//
//    return newImage;
//}

+ (UIImage *)fliter:(NSString *)filterName image:(UIImage *)image
{
    if ([filterName isEqualToString:@"OriginImage"]) {
        return image;
    }
    //将UIImage转换成CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    
    //已有的值不改变，其他的设为默认值
    [filter setDefaults];
    
    //获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    
    //创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //获取图片
    UIImage *img = [UIImage imageWithCGImage:cgImage];
    
    //释放CGImage句柄
    CGImageRelease(cgImage);
    
    return  img;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage == nil) {
        return nil;
    }
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// 将UIView转成UIImage
+ (UIImage *)imageFromView:(UIView *)theView opaque:(BOOL)opaque
{
    CGSize orgSize = theView.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(orgSize, opaque, theView.layer.contentsScale * 3);//todo
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (opaque == NO) {
        NSData* data = UIImagePNGRepresentation(image);
        image = [UIImage imageWithData:data];
    }
    
    return image ;
}

//设置图片的透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageNamed:(NSString *)name renderingModel:(UIImageRenderingMode)model;
{
    return [[UIImage imageNamed:name] imageWithRenderingMode:model];
}

@end
