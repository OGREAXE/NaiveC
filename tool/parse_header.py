import re
import os
import sys
import getopt

def writeline(line):
    #print(line)
    print(line, file=f)
  
def find_and_write_enums(headerpath, outpath, userealvalue = True):
    
    print("header path is " + headerpath)
    
    all_filenames = []
    for (dirpath, dirnames, files) in os.walk(headerpath):
        for file in files:
            if file.endswith(".h") or file.endswith(".m"):
                all_filenames.append(os.path.join(dirpath, file))
        #break
        
    print("all header files :")
    print(all_filenames)
    #all_filenames = ["./UIKit/Headers/UIWindowSceneGeometry.h"]

    global f
    f = open(outpath, "w")

    classname = os.path.split(outpath)[1].split(".")[0]
    
    print("building interface " + classname)
    #print("output path :" + outpath)

    writeline(f'#import "{classname}.h"');
    writeline('#import "UIKit/UIKit.h"');
    writeline('#import "AVFoundation/AVFoundation.h"');
    writeline('')
    writeline(f'@implementation {classname}')
    writeline('+(id)enumForName:(NSString *)name {')
    writeline('   static NSDictionary *store = nil;')
    writeline('   static dispatch_once_t onceToken;')
    writeline('    dispatch_once(&onceToken, ^{')
    writeline('    store = @{')

    total = 0
    
    ignore_enums = ["UITitlebarSeparatorStyle","UITitlebarTitleVisibility","UITitlebarToolbarStyle"]
    ignore_enum_fields = ["UITextFieldDidEndEditingReasonCancelled", "NSItemProviderRepresentationVisibilityGroup"]
    
    for filename in all_filenames:
         
        #with open("./Headers/UIControl.h") as f:
        with open(filename) as fin:
            try:
                data = fin.read()
            except UnicodeDecodeError as e:
                print("decode error :" + filename)
                continue
        #print(data)

        all_matches = re.findall("(NS_ENUM|NS_OPTIONS|NS_CLOSED_ENUM)\\(.*?,(.*?)\\) *\\s\\{((.|\\s)*?)\\}(.*?);\\s", data)
        #print(all_matches)
        
        if len(all_matches)>0:
            writeline("")
            writeline("//   Enum definitions in " + filename)
        
        for match in all_matches:
            writeline("//  " + match[1])
            
            if match[1].strip() in ignore_enums:
                print("ignoring " + match[1])
                continue
            
            if len(match[4])>1:
                #print(match[4])
                unav = re.search("API_UNAVAILABLE\\((.*?)\\)", match[4])
                if unav:
                    #print(unav.group(1))
                    
                    if 'ios' in unav.group(1):
                        print (match[1] + ' is not available in iOS')
                        continue
            
            #print(match[2])
            
            lines = match[2].splitlines()
            iscommment = False
            
            currentvalue = 0
            
            for l in lines:
                    
                lunav = re.search("API_UNAVAILABLE\\((.*?)\\)", l)
                if lunav:
                    #print(unav.group(1))
                    
                    if 'ios' in lunav.group(1):
                        print (l + ' is not available in iOS')
                        continue
                    
                l = l.strip()
                
                if l.startswith('/*'):
                    iscommment = True
                    continue;
                
                if l.endswith('*/') and iscommment:
                    iscommment = False
                    continue;
                    
                if iscommment:
                    continue
                
                if userealvalue:
                    e = l.split(",")[0].split("=")
                    
                    key = e[0].strip()
                    
                    if not key:
                        continue
                    
                    if not key[0].isalpha():
                        continue;
                        
                    if len(e) == 1:
                        if e :
                            writeline('            @"' + key + f'":P({currentvalue}),')
                            total += 1
                        
                        currentvalue += 1
                        
                    elif len(e) == 2:
                        rawvalue = e[1].strip().split("//")[0].split("/*")[0].strip()
                        
                        if "<<" in rawvalue:
                            writeline('            @"' + key + f'":P({rawvalue}),')
                            total += 1
                        elif rawvalue.isnumeric() or "0x" in rawvalue:
                            if "0x" in rawvalue:
                                currentvalue = int(rawvalue, 16)
                            else:
                                currentvalue = int(rawvalue)
                            
                            if e :
                                writeline('            @"' + key + f'":P({currentvalue}),')
                                total += 1
                                
                            currentvalue += 1
                        elif rawvalue.startswith("NS") or rawvalue.startswith("UI"):
                            writeline('            @"' + key + f'":P({rawvalue}),')
                        
                    else:
                        print("fail to parse :" + l)
                    
                else:
                    e = l.split(",")[0].split("=")[0].split()

                    key = e[0].strip()
                    
                    if not key:
                        continue
                    
                    if not key[0].isalpha():
                        continue;
                        
                    if e and key != "return" and key not in ignore_enum_fields:
                        writeline('            @"' + key + '":P(' + key + '),')
                        total += 1

    writeline("")
    writeline(f'//total entry count is {total}')

    writeline('        };')
    writeline('    });')
    writeline('')
    writeline('    return store[name];')
    writeline('}')
    writeline('@end')
    
def main(argv):
    
    headerpath = "./"
    outpath = "../Bridged/wrapper/NCLocalEnumStore.m"

    userealvalue = True
    
    try:
        opts, args = getopt.getopt(argv,"shi:o:",["ipath=","ofile="])
    except getopt.GetoptError:
        print ("getopt error")
        print ('usage: parse_header.py -i <inputpath> -o <outputfile> -s')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
           print ('parse_header.py -i <inputpath> -o <outputfile> -s')
           sys.exit()
        elif opt in ("-s", "--system"):
            userealvalue = False
        elif opt in ("-i", "--ipath"):
            headerpath = arg
        elif opt in ("-o", "--ofile"):
            outpath = arg
            
    print ('Input path is ', headerpath)
    print ('Output file is ', outpath)
    
    find_and_write_enums(headerpath, outpath, userealvalue)
   
if __name__ == "__main__":
    main(sys.argv[1:])
