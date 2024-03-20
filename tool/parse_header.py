import re
import os

headerpath = "./"

all_filenames = []
for (dirpath, dirnames, files) in os.walk(headerpath):
    for file in files:
        all_filenames.append(os.path.join(dirpath, file))
    #break
    
#print(all_filenames)
#all_filenames = ["./UIKit/Headers/UIWindowSceneGeometry.h"]

f = open("NCCocoaEnumStore.m", "w")

def writeline(line):
  print(line, file=f)

writeline('#import "NCCocoaEnumStore.h"');
writeline('#import "UIKit/UIKit.h"');
writeline('')
writeline('@implementation NCCocoaEnumStore')
writeline('+(id)enumForName:(NSString *)name {')
writeline('   static NSDictionary *store = nil;')
writeline('   static dispatch_once_t onceToken;')
writeline('    dispatch_once(&onceToken, ^{')
writeline('    store = @{')

total = 0

for filename in all_filenames:
    if not filename.endswith(".h"):
        continue
        
    writeline("/*")
    writeline("     Enum definitions in " + filename)
    writeline("*/")
        
    #with open("./Headers/UIControl.h") as f:
    with open(headerpath + filename) as fin:
        data = fin.read()
         
    #print(data)

    all_matches = re.findall("(NS_ENUM|NS_OPTIONS)\\(.*?,(.*?)\\) *\\s\\{((.|\\s)*?)\\}(.*?);\\s", data)
    #print(all_matches)
    for match in all_matches:
        writeline("//     " + match[1])
        
        if len(match[4])>1:
            #print(match[4])
            unav = re.search("API_UNAVAILABLE\\((.*?)\\)", match[4])
            if unav:
                #print(unav.group(1))
                
                if 'ios' in unav.group(1):
                    print (match[1] + ' is not available in iOS')
                    continue
        
        lines = match[2].splitlines()
        iscommment = False
        for l in lines:
            if iscommment:
                continue
                
            lunav = re.search("API_UNAVAILABLE\\((.*?)\\)", l)
            if lunav:
                #print(unav.group(1))
                
                if 'ios' in lunav.group(1):
                    print (l + ' is not available in iOS')
                    continue
                
            l = l.strip()
            
            if l.startswith('/*'):
                iscommment = True
            
            if l.endswith('*/'):
                iscommment = False
            
            e = l.split(",")[0].split("=")[0].split()
            if e and e[0].isalpha() and e[0] != "return":
                writeline('            @"' + e[0] + '":P(' + e[0] + '),')
                total += 1

writeline("")
writeline(f'//total entry count is {total}')

writeline('        };')
writeline('    });')
writeline('')
writeline('    return store[name];')
writeline('}')
writeline('@end')
