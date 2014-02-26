//
//  NSString+WizString.m
//  Wiz
//
//  Created by 朝 董 on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+WizString.h"
#import <wchar.h>
#import <string>
#import <stdio.h>
#import <stdlib.h>
#import <CommonCrypto/CommonDigest.h>


bool IsScriptOrStyle(const wchar_t* p)
{
	if (*p == 's' || *p == 'S')
	{
		p++;
		if (*p == 'c' || *p == 'C')
		{
			p++;
			//
			if (*p == 'r' || *p == 'R')
			{
				p++;
				if (*p == 'i' || *p == 'I')
				{
					p++;
					if (*p == 'p' || *p == 'P')
					{
						p++;
						if (*p == 't' || *p == 'T')
						{
							p++;
							if (isspace(*p)
								|| *p == '>')
							{
								return true;
							}
						}
					}
				}
			}
		}
		else if (*p == 't' || *p == 'T')
		{
			p++;
			if (*p == 'y' || *p == 'Y')
			{
				p++;
				//
				if (*p == 'l' || *p == 'L')
				{
					p++;
					if (*p == 'e' || *p == 'E')
					{
						p++;
						if (isspace(*p)
                            || *p == '>')
						{
							return true;
						}
					}
				}
			}
		}
	}
	//
	return false;
}
//
bool IsSpaceString(const wchar_t* pTextBegin, const wchar_t* pTextEnd)
{
	while (pTextBegin < pTextEnd)
	{
		if (*pTextBegin == ' '
			|| *pTextBegin == '\t'
			|| *pTextBegin == '\r'
			|| *pTextBegin == '\n')
		{
			pTextBegin++;
			continue;
		}
		//
		return false;
	}
	//
	return true;
}
//
bool IsInScriptOrStyleTag(const wchar_t* p, const wchar_t* pTextBegin)
{
	while (pTextBegin >= p)
	{
		if (*pTextBegin == '<')
		{
			pTextBegin++;
			return IsScriptOrStyle(pTextBegin);
		}
		else
		{
			pTextBegin--;
		}
	}
	//
	return false;
}
//
bool FindTextBegin(const wchar_t* p, const wchar_t*& pTextBegin, const wchar_t*& pTextEnd)
{
	const wchar_t* pBegin = p;
	//
	while (1)
	{
		p = wcschr(p, '>');
		if (NULL == p)
			return false;
		//
		p++;
		pTextBegin = p;
		//
		pTextEnd = wcschr(pTextBegin, '<');
		if (NULL == pTextEnd)
			return false;
		//
		p = pTextEnd;
		//
		if (pTextEnd - pTextBegin <= 1)	//empty text tag
			continue;
		//
		if (IsSpaceString(pTextBegin, pTextEnd))
			continue;
		//
		if (IsInScriptOrStyleTag(pBegin, pTextBegin))
			continue;
		//
		return true;
	}
}

void FindAllText(std::wstring& html, int maxSize)
{
    std::wstring strRet;
    if (maxSize > 0) {
        strRet.reserve(maxSize * 2);
    }
    else
    {
        strRet.reserve(html.length());
    }
	//
	const wchar_t* p = html.c_str();
	//
	while (1)
	{
		const wchar_t* pTextBegin = NULL;
		const wchar_t* pTextEnd = NULL;
		//
		if (FindTextBegin(p, pTextBegin, pTextEnd))
		{
			//
			strRet = strRet + std::wstring(L" ") + std::wstring(pTextBegin, pTextEnd);
            if (strRet.length() >= maxSize && maxSize > 0) {
                break;
            }
			//
			p = pTextEnd;
			//
			continue;
		}
		else
		{
			break;
		}
	}
	//
	html = strRet;
}

void AddWizTagToHtml(std::wstring& html)
{
	std::wstring strRet;
    
	strRet.reserve(html.length() * 2);
	//
	const wchar_t* p = html.c_str();
	//
	while (1)
	{
		const wchar_t* pTextBegin = NULL;
		const wchar_t* pTextEnd = NULL;
		//
		if (FindTextBegin(p, pTextBegin, pTextEnd))
		{
			strRet += std::wstring(p, pTextBegin);
			//
			strRet += L"<wiz>" + std::wstring(pTextBegin, pTextEnd) + L"</wiz>";
			//
			p = pTextEnd;
			//
			continue;
		}
		else
		{
			strRet += p;
			break;
		}
	}
	//
	html = strRet;
}


@implementation NSString (WizString)


- (NSComparisonResult) compareFirstCharacter:(NSString*)string
{
    return [[self pinyinFirstLetter] compare:[string pinyinFirstLetter]];
}

- (NSComparisonResult) compareByChinese:(NSString*)string
{
    return [[self pinyinFirstLettersForSentence] compare:[string pinyinFirstLettersForSentence]];
}
//

- (NSString*) pinyinFirstLettersForSentence
{
//    if ([self isEqualToString:@""] || self.length <1) {
//        return @"#";
//    }
//    NSMutableString* chineseFLs= [NSMutableString string];
//    for (int i=0 ; i< self.length; i++) {
//        [chineseFLs appendFormat:@"%c",pinyinFirstLetter([self characterAtIndex:i])];
//    }
//    return [chineseFLs uppercaseString];
    return nil;
}

- (NSString*) pinyinFirstLetter
{
//    if ([self isEqualToString:@""] || self.length <1) {
//        return @"#";
//    }
//    return  [[NSString stringWithFormat:@"%c",pinyinFirstLetter([self characterAtIndex:0])] uppercaseString];
    return nil;
}
- (BOOL) isBlock
{
    return self == nil ||[self isEqualToString:@""];
}
- (NSString*) fileName
{
    return [[self componentsSeparatedByString:@"/"] lastObject];
}
- (NSString*) fileType
{
    NSString* fileName = [self fileName];
    if (fileName == nil || [fileName isBlock]) {
        return nil;
    }
    return [[fileName componentsSeparatedByString:@"."] lastObject];
}

- (NSString*) stringReplaceUseRegular:(NSString *)regex withString:(NSString*)replaceStr
{
    @try {
        if (self) {
            NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
            return [reg stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:replaceStr];
        }

    }
    @catch (NSException *exception) {
        return self;
    }
    @finally {
            
    }
    
}


- (NSString*) parentPath
{
    NSString* str = [self stringByDeletingLastPathComponent];
    if ([str hasSuffix:@"/"]) {
        return str;
    }
    else
    {
        return [str stringByAppendingString:@"/"];
    }
}

- (NSString*) stringAppendingPath:(NSString *)path
{
    if (self) {
        if ([self hasSuffix:@"/"]) {
            return [self stringByAppendingFormat:@"%@",path];
        }
        else
        {
            return [self stringByAppendingFormat:@"/%@",path];
        }
    }
    else
    {
        return [@"/" stringAppendingPath:path];
    }
}

- (NSString*) stringReplaceUseRegular:(NSString*)regex
{
    @try {
        if (self) {
            NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:nil];
            return [reg stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""];
        }
    }
    @catch (NSException *exception) {
        return self;
    }
    @finally {
        
    }
    
}

- (NSDate *) dateFromSqlTimeString
{
    static NSDateFormatter* formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    if (self.length < 19) {
        return nil;
    }
    @synchronized(formatter)
    {
        NSDate* date = [formatter dateFromString:self];
        return date;
    }
}
//
-(NSString*) trim
{
	NSString* ret = [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];	
	return ret;
}
-(NSString*) trimChar: (unichar)ch
{
	NSString* str = [NSString stringWithCharacters:&ch length: 1];
	NSCharacterSet* cs = [NSCharacterSet characterSetWithCharactersInString: str];
	//
	return [self stringByTrimmingCharactersInSet: cs];	
}

-(int) indexOfChar:(unichar)ch
{
	NSString* str = [NSString stringWithCharacters:&ch length: 1];
	//
	return [self indexOf: str];
}
-(int) indexOf:(NSString*)find
{
	NSRange range = [self rangeOfString:find options:NSCaseInsensitiveSearch];
	if (range.location == NSNotFound)
		return NSNotFound;
	//
	return range.location;
}

- (NSInteger) indexOf:(NSString *)find compareOptions:(NSStringCompareOptions)mask
{
    NSRange range = [self rangeOfString:find options:mask];
    if (range.location == NSNotFound) {
        return NSNotFound;
    }
    return range.location;
}
-(int) lastIndexOfChar: (unichar)ch
{
	NSString* str = [NSString stringWithCharacters:&ch length: 1];
	//
	return [self lastIndexOf: str];
}
-(int) lastIndexOf:(NSString*)find
{
	NSRange range = [self rangeOfString:find options:NSBackwardsSearch|NSCaseInsensitiveSearch];
	if (range.location == NSNotFound)
		return NSNotFound;
	//
	return range.location;
}

-(NSString*) toValidPathComponent
{
	NSMutableString* name = [[NSMutableString alloc] initWithString:self] ;
	//
	[name replaceOccurrencesOfString:@"\\" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"/" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"'" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"\"" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@":" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"*" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"?" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"<" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@">" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"|" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"!" withString:@"-" options:0 range:NSMakeRange(0, [name length])];
	//
	if ([name length] > 50)
	{
		return [name substringToIndex:50];
	}
	//
	return name;
}

-(NSString*) firstLine
{
	NSString* text = [self trim];
	int index = [text indexOfChar:'\n'];
	if (NSNotFound == index)
		return text;
	return [[text substringToIndex:index] trim];
}

- (NSString*) fromHtml
{
    if (!self) {
        return nil;
    }
    NSMutableString* name = [[NSMutableString alloc] initWithString:self];
	//
	[name replaceOccurrencesOfString:@"" withString:@"\r" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"&amp;" withString:@"&" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"&gt;" withString:@"<" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"&lt;" withString:@">" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"<br>" withString:@"\n" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"&nbsp;&nbsp;&nbsp;&nbsp;" withString:@"\t" options:0 range:NSMakeRange(0, [name length])];
	return name ;
}

- (NSString*) nToHtmlBr
{
    return [self stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
}

-(NSString*) toHtml
{
    if (!self) {
        return nil;
    }
	NSMutableString* name = [[NSMutableString alloc] initWithString:self] ;
	//
	[name replaceOccurrencesOfString:@"\r" withString:@"" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"&" withString:@"&amp;" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"<" withString:@"&gt;" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@">" withString:@"&lt;" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"\n" withString:@"<br>" options:0 range:NSMakeRange(0, [name length])];
	[name replaceOccurrencesOfString:@"\t" withString:@"&nbsp;&nbsp;&nbsp;&nbsp;" options:0 range:NSMakeRange(0, [name length])];
    [name replaceOccurrencesOfString:@" " withString:@"&nbsp;" options:0 range:NSMakeRange(0, [name length])];
    
	return name ;
	
}

- (NSString *)URLEncodedString{    
    NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    return  result ;
}
- (NSString*)URLDecodedString{
    __autoreleasing NSString *result = (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           kCFStringEncodingUTF8);
    return result ;
}

- (BOOL) checkHasInvaildCharacters
{
    NSError* error = nil;
    NSRegularExpression* regular = [NSRegularExpression regularExpressionWithPattern:@"[\\,/,:,<,>,*,?,\",&,\"]" options:NSRegularExpressionCaseInsensitive error:&error] ;
    NSArray* regularArray = [regular  matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if (regularArray && [regularArray count]) {
        return YES;
    }
    return NO;
}

- (BOOL) writeToFile:(NSString *)path useUtf8Bom:(BOOL)isWithBom error:(NSError **)error
{
    
    char BOM[] = {static_cast<char>(0xEF), static_cast<char>(0xBB), static_cast<char>(0xBF)};
    NSMutableData* data = [NSMutableData data];
    [data appendBytes:BOM length:3];
    [data appendData:[self dataUsingEncoding:NSUTF8StringEncoding]];
    NSFileManager* fileNamger = [NSFileManager defaultManager];
    if ([fileNamger fileExistsAtPath:path]) {
        [fileNamger removeItemAtPath:path error:nil];
    }
    [data writeToFile:path atomically:YES];
    return YES;
}
+(NSString*)getStringFromWChar:(const wchar_t*) inStr
{
    setlocale(LC_CTYPE, "UTF-8");
    int strLength = wcslen(inStr);
    int bufferSize = (strLength+1)*4;
    char *stTmp = (char*)malloc(bufferSize);
    memset(stTmp, 0, bufferSize);
    wcstombs(stTmp, inStr, strLength);
    NSString* ret = [[NSString alloc] initWithBytes:stTmp length:strlen(stTmp) encoding:NSUTF8StringEncoding] ;
    free(stTmp);
    return ret ;
}

- (std::wstring) getWCharFromString
{

    const char  *cString;
    cString = [self cStringUsingEncoding:NSUTF8StringEncoding];
    setlocale(LC_CTYPE, "UTF-8");
    int iLength = mbstowcs(NULL, cString, 0);
    int bufferSize = (iLength+1)*sizeof(wchar_t);
    wchar_t *stTmp = (wchar_t*)malloc(bufferSize);
    memset(stTmp, 0, bufferSize);
    mbstowcs(stTmp, cString, iLength);
    stTmp[iLength] = 0;
    std::wstring wstr(stTmp);
    free(stTmp);
    return wstr;
}

NSRange (^htmlTagRangeClose)(NSString*, NSString*) = ^(NSString* string,NSString* tag)
{
    if( nil == string)
    {
        return NSMakeRange(NSNotFound, NSNotFound);
    }
    NSString* patterns = [NSString stringWithFormat:@"<%@[^>]*>([\\s\\S]*)</%@>",tag,tag];
    NSRegularExpression*  headRegular = [NSRegularExpression regularExpressionWithPattern:patterns options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange headRange = NSMakeRange(0, 0);
    NSArray* heads = [headRegular matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult* eachResult in heads)
    {
        if ([eachResult range].length > headRange.length)
        {
            headRange = [eachResult range];
        }
    }
    
    return headRange;
};

NSRange (^indexOfHtmlTag)(NSString*, NSString*, BOOL) = ^(NSString* string,NSString* tag,BOOL needFirst)
{
    if( nil == string)
    {
        return NSMakeRange(NSNotFound, NSNotFound);
    }
    NSString* patterns = [NSString stringWithFormat:@"%@",tag];
    NSRegularExpression*  headRegular = [NSRegularExpression regularExpressionWithPattern:patterns options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* heads = [headRegular matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    if(heads && [heads count])
    {
        return [[heads objectAtIndex:0] range];
    }
    return NSMakeRange(NSNotFound, NSNotFound);
};

- (NSString*) getBody
{
    NSRange  bodyRange = htmlTagRangeClose(self,@"body");
    if (bodyRange.length == 0 ) {
        NSInteger  lastIndexOfHtml = [self lastIndexOf:@"</html>"];
        NSInteger lastIndexOfHead = [self lastIndexOf:@"</head>"];
        NSRange htmlRange = indexOfHtmlTag(self,@"<html[^>]*>",YES);
        NSInteger subStartPos = 0;
        NSInteger subEndPos = lastIndexOfHtml == NSNotFound? self.length:lastIndexOfHtml;
        //
        if (lastIndexOfHead != NSNotFound) {
            subStartPos = lastIndexOfHead + 7;
        }
        else
        {
            if (htmlRange.length != NSNotFound) {
                subStartPos = htmlRange.location + htmlRange.length;
            }
        }
        return [NSString stringWithFormat:@"<body>%@</body>",[self substringWithRange:NSMakeRange(subStartPos, subEndPos-subStartPos)]];
    }
    return [self substringWithRange:bodyRange];
}
- (NSString*) processHtml
{
    if (nil == self) {
        return nil;
    }
    std::wstring str = [[self getBody] getWCharFromString];
    AddWizTagToHtml(str);
    return [[NSString getStringFromWChar:str.c_str()] stringReplaceUseRegular:@"<body[^>]*>"];
}

- (NSString*) htmlToText:(int)maxSize
{
    if (nil == self) {
        return nil;
    }
    std::wstring str = [[self getBody] getWCharFromString];
    FindAllText(str, maxSize);
    return [NSString getStringFromWChar:str.c_str()];
}

- (NSArray*) separateTagGuids
{
    if ([self indexOf:@"*"] != NSNotFound) {
        return [self componentsSeparatedByString:@"*"];
    }
    else if ([self indexOf:@";"] != NSNotFound)
    {
        return [self componentsSeparatedByString:@";"];
    }
    else if (![self isEqualToString:@""])
    {
        return @[self];
    }
    return [NSArray array];
}

- (NSString*) constructTagGuids:(NSArray*)tags
{
    NSMutableString* tagGuids = [NSMutableString string];
    for (int i = 0; i < [tags count]; ++i) {
        NSString* guid = [ tags objectAtIndex:i];
        [tagGuids appendString:guid];
        if (i != [tags count] - 1) {
            [tagGuids appendString:@"*"];
        }
    }
    return tagGuids;
}

- (NSString*) removeTagguid:(NSString *)tagGuid
{
    NSMutableArray* tags = [NSMutableArray arrayWithArray:[self separateTagGuids]];
    NSInteger indexOfTag = NSNotFound;
    for (int i = 0; i < [tags count]; ++i) {
        if ([[tags objectAtIndex:i] isEqualToString:tagGuid]) {
            indexOfTag = i;
            break;
        }
    }
    if (indexOfTag != NSNotFound) {
        [tags removeObjectAtIndex:indexOfTag];
    }
    return [self constructTagGuids:tags];
}

- (NSString*) stringByInt64_t:(int64_t)value
{
    return [NSString stringWithFormat:@"%lld",value];
}

- (NSString*)getAtString
{
    NSMutableString* atUsersNameString = [NSMutableString string];//@[^@ ]+"
    NSRegularExpression* reg = [NSRegularExpression regularExpressionWithPattern:@"@[^\\s]+" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array = [reg matchesInString:self options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, self.length)];
    for (NSTextCheckingResult *match in array) {
        NSInteger count = [match numberOfRanges];
        for(NSInteger index = 0;index<count;index++){
            NSRange halfRange = [match rangeAtIndex:index];
            [atUsersNameString appendFormat:@"%@%@",[self substringWithRange:halfRange],@" "];
        }
    }
    return atUsersNameString;
}

- (NSString*)exceptAtString
{
    NSString* withOutAtString = [self stringReplaceUseRegular:@"@[^\\s]+" withString:@""];
    if (!withOutAtString || [[withOutAtString trim] isBlock]) {
        return nil;
    }
     return withOutAtString;
}


- (NSString*) folderFormat
{
    NSString* str;
    if (![self hasPrefix:@"/"]) {
        str  = [NSString stringWithFormat:@"%@%@",@"/",self];
    }
    if (![self hasSuffix:@"/"]) {
        str  = [self stringByAppendingString:@"/"];
    }
    return str ;
}

- (NSString*)deleteLastPathComponent
{
    NSRange range = [self rangeOfString:@"//"];
    if (range.location == NSNotFound) {
        return [self stringByDeletingLastPathComponent];
    }else{
        NSString* string = [[NSString alloc]initWithString:self];
        if ([string hasSuffix:@"/"]) {
            string = [string substringToIndex:[string length] - 1];
        }
        NSRange lastRange = [string rangeOfString:@"/" options:NSBackwardsSearch];
        if (lastRange.location != NSNotFound) {
             return [string substringToIndex:lastRange.location];
        }else{
            return string;
        }
    }
    return self;
}

+ (NSString*) stringMSFromTimeInterval:(NSTimeInterval) ftime
{
    NSInteger totalTime = ceil(ftime);
    NSInteger s = totalTime % 60;
    NSInteger m = totalTime / 60 % 60;
    return [NSString stringWithFormat:@"%002d:%002d",m,s];
}

+ (NSString*) stringHMSFromTimeInterval:(NSTimeInterval) ftime
{
    NSInteger totalTime = ceil(ftime);
    NSInteger s = totalTime % 60;
    NSInteger m = totalTime / 60 % 60;
    NSInteger h = totalTime / 60 / 60 % 24;
    return [NSString stringWithFormat:@"%002d:%002d:%002d",h,m,s];
}

+ (NSString*) stringDHMSFromTimeInterval:(NSTimeInterval) ftime
{
    NSInteger totalTime = ceil(ftime);
    NSInteger s = totalTime % 60;
    NSInteger m = totalTime / 60 % 60;
    NSInteger h = totalTime / 60 / 60 % 24;
    NSInteger d = totalTime / 60 /60 / 24;
    return [NSString stringWithFormat:@"%002d:%002d:%002d:%002d",d,h,m,s];
}

+ (NSString*) readableTimeStringWithInterval:(NSTimeInterval)ftime
{
    NSInteger totalTime = ceil(ftime);
    NSInteger s = totalTime % 60;
    NSInteger m = totalTime / 60 % 60;
    NSInteger h = totalTime / 60 / 60 % 24;
    NSInteger d = totalTime / 60 /60 / 24;
    if (d > 0) {
        return [NSString stringWithFormat:@"%d天多", d];
    } else {
        if (h > 0) {
            return [NSString stringWithFormat:@"%d:%d",h, m];
        } else if (s > 0)
        {
            return [NSString stringWithFormat:@"%d\"%d'",m,s];
        } else {
            return [NSString stringWithFormat:@"%d'",s];
        }
    }
}

- (NSString *) MD5Hash {
    
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], [self length]);
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
    
}


@end

NSString* (^Int64ToString)(int64_t)= ^(int64_t value){
    return [NSString stringWithFormat:@"%lld",value];
};

NSString* (^Int32ToString)(int32_t)=^(int32_t value)
{
    return [NSString stringWithFormat:@"%d",value];
};
NSString* (^BoolTOString)(BOOL) = ^(BOOL value)
{
    return [NSString stringWithFormat:@"%d",value];
};
