//
//  TBPaserTool.m
//  TBParserDemo
//
//  Created by 崔健 on 2017/11/4.
//  Copyright © 2017年 cy. All rights reserved.
//

#import "TBPaserTool.h"
@interface TBPaserTool ()
@property (nonatomic, assign) Byte *inputBytes;    // 数据缓冲区收地址
@property (nonatomic, assign) Byte *currentByte;   // 当前解析位置的地址
@end
@implementation TBPaserTool
/**
 *  传入文件路径开始解析
 */
+ (NSDictionary *)parseWithFilePath:(NSString *)path{
    
    if (!path) {
        return nil;
    }
    TBPaserTool *tool = [[self alloc]init];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    Byte *bytes = (Byte *)[data bytes];
    NSDictionary* result = [tool parseWithBytes:bytes];
    return result;
}

/**
 *  传入bytes开始解析
 */
- (NSDictionary *)parseWithBytes:(Byte *)bytes{
    self.currentByte = bytes;
    self.inputBytes = bytes;
    NSDictionary* result = [self parse];
    return result;
}

/**
 *  从缓冲区提取一定数量的字符串，并移动当前指针
 */
- (NSString *)getStrWithNumber:(NSInteger)number{
    Byte desByte[number];
    for (NSInteger i = 0; i < number; i++) {
        Byte byte = *(self.currentByte + i);
        if (byte == '\0') { // 如果文件出错提前结束
            return nil;
        }
        desByte[i] = byte;
    }
    
    NSString *resultStr = [[NSString alloc] initWithData:[NSData dataWithBytes:desByte length:number] encoding:NSUTF8StringEncoding];
    self.currentByte = self.currentByte + number;   // 移动当前指针到获取
    return resultStr;
}

/**
 *  解析整数
 */
- (NSNumber *)parseInteger{
    NSMutableString *tempStr = [NSMutableString string];
    while (YES) {
        NSString *str = [self getStrWithNumber:1];
        if (str == nil) {
            return nil;
        }
        if ([str isEqualToString:@"e"]) {
            break;
        }else{
            [tempStr appendString:str];
        }
    }
    
    return [NSNumber numberWithLong:[tempStr longLongValue]];
}

/**
 *  解析字符串，传入的字符串为第一个字符
 */
- (NSString *)parseStrWithStr:(NSMutableString *)strM{
    while (YES) {
        
        NSString *str = [self getStrWithNumber:1];
        if (!str) {
            return nil;
        }
        
        if ([str isEqualToString:@":"]){
            break;
        }else{
            [strM appendString:str];
        }
    }
    
    NSInteger length = [strM integerValue];
    NSString *result = [self getStrWithNumber:length];
    if (!result) {
        return nil;
    }
    return result;
}

/**
 *  解析主方法，通过不断的递归，找到最里层的要么是字符串，要么是数字。再由上面的方法解析字符串
 *  和数字完成。
 */
- (id)parse{
    
    while (YES) {
        NSString *tempStr = [self getStrWithNumber:1];
        if (!tempStr) {
            return nil;
        }
        if ([tempStr isEqualToString:@"d"]) { // 检测到字典
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            NSString *key = [self parse]; // 字典后的第一个必为字符串
            while (key) {
                id value = [self parse];
                if (value) {
                    [dictM setObject:value forKey:key];
                }
                
                key = [self parse];
            }
            return dictM.copy;
        }else if ([tempStr isEqualToString:@"l"]){ // 检测到数组
            
            NSMutableArray *arrM = [NSMutableArray array];
            id value = [self parse];
            while (value) {
                [arrM addObject:value];
                value = [self parse];
            }
            return arrM.copy;
        }else if([tempStr isEqualToString:@"i"]){ // 检测到整数
            
            NSNumber *value = [self parseInteger];
            return value;
        }else if ([tempStr isEqualToString:@"e"]){ // 检测到结束
            
            return nil;
        }else{ // 剩下的为字符串
            
            return [self parseStrWithStr:tempStr.mutableCopy];
        }
    }
    
    return nil;
}

@end
