# NaiveC
A script interpreter supports simple grammar

can call Objective-C class and method directly, means you can write OC code as scripts
## Grammar
 * variable initialization:
 ```
     aInt = 1
     aFloat = 0.5
     aStr = "helloworld"
     aArray = {1,2,3}
 ```
   
 * loop(for and while):
 ``` 
   for(i=0;i<16;i++)
 ```
   
   or 
 ```
   for(e:array) //if array is a fast-enumerable object, such as native array or NSArray
 ```
 
 * conditional
 ```  
   if(a>=0){
       print(a + " is greater than 0")
   }
   else{
       print(a + " is lower than 0")
   }
```
 * function call
 ``` 
   print("Hello world")
 ```
 ## integration with Objective-C and Cocoaframework
  * objc style send message
  ``` 
   time = [NSDate date]
   print(time)
 ```
 
