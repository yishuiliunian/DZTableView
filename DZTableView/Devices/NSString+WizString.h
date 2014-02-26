//
//  NSString+WizString.h
//  Wiz
//
//  Created by 朝 董 on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* (^Int64ToString)(int64_t);
extern NSString* (^Int32ToString)(int32_t);
extern NSString* (^BoolTOString)(BOOL);

@interface NSString (WizString)
- (BOOL) isBlock;
- (NSString*) fileName;
- (NSString*) fileType;
- (NSString*) stringReplaceUseRegular:(NSString*)regex;
- (NSString*) stringReplaceUseRegular:(NSString *)regex withString:(NSString*)replaceStr;
- (NSDate *) dateFromSqlTimeString;
//help
- (NSString*) trim;
- (NSString*) trimChar:(unichar) ch;
- (int) indexOfChar:(unichar)ch;
- (int) indexOf:(NSString*)find;
- (int) lastIndexOfChar: (unichar)ch;
- (int) lastIndexOf:(NSString*)find;
- (NSString*) firstLine;
- (NSString*) toHtml;
- (NSString*) pinyinFirstLetter;
- (NSString*) pinyinFirstLettersForSentence;
- (NSString*) toValidPathComponent;
- (NSComparisonResult) compareByChinese:(NSString*)string;

- (NSComparisonResult) compareFirstCharacter:(NSString*)string;

- (NSString *)URLEncodedString;
- (NSString*)URLDecodedString;
- (NSString*) fromHtml;
- (NSString*) nToHtmlBr;
//
- (BOOL) writeToFile:(NSString *)path useUtf8Bom:(BOOL)isWithBom error:(NSError **)error;
//
- (NSInteger) indexOf:(NSString *)find compareOptions:(NSStringCompareOptions)mask;

- (BOOL) checkHasInvaildCharacters;
- (NSString*) processHtml;
- (NSString*) htmlToText:(int)maxSize;
//
- (NSArray*)  separateTagGuids;
- (NSString*)  removeTagguid:(NSString*)tagGuid;
- (NSString*) stringAppendingPath:(NSString*)path;

- (NSString*) parentPath;
- (NSString*) getAtString;
- (NSString *) MD5Hash;
- (NSString*) exceptAtString;
+ (NSString*) stringMSFromTimeInterval:(NSTimeInterval) ftime;
+ (NSString*) stringHMSFromTimeInterval:(NSTimeInterval) ftime;
+ (NSString*) stringDHMSFromTimeInterval:(NSTimeInterval) ftime;

- (NSString*) folderFormat;
- (NSString*) deleteLastPathComponent;

+ (NSString*) readableTimeStringWithInterval:(NSTimeInterval) ftime;
@end
