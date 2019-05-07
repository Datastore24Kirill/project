//
//  ViewForPickers.m
//  Hookah Manager
//
//  Created by Виктор Мишустин on 2/10/17.
//  Copyright © 2017 Viktor Mishustin. All rights reserved.
//

#import "ViewForPickers.h"

@interface ViewForPickers ()

@property (strong, nonatomic) NSArray * arrayData;

@end

@implementation ViewForPickers
@synthesize delegate;
- (void) createPickersWithData: (NSArray*) data andNext:(BOOL) next count:(NSInteger) count {
    
    self.arrayData = data;
    
    self.pickerHours = [[UIPickerView alloc] initWithFrame:self.bounds];
    self.pickerHours.delegate = self;
    self.pickerHours.dataSource = self;
    self.pickerHours.showsSelectionIndicator = YES;
    NSDictionary * timeDict;
    if(self.arrayData.count>0){
        
        if(!next){
            timeDict = [self.arrayData objectAtIndex:0];
            
        }else{
            if(count>1){
                timeDict = [self.arrayData objectAtIndex:1];
            }else{
                timeDict = [self.arrayData objectAtIndex:0];
            }
            
        }
        
        NSString * hour = [timeDict objectForKey:@"hours"];
        NSString * minute = [[timeDict objectForKey:@"minutes"] objectAtIndex:0];
        NSString * resultTime = [NSString stringWithFormat:@"%@:%@",hour, minute];
        [self.delegate setChooseTime:resultTime];
        
        NSLog(@"CHOOSETIME %@",resultTime);
    }
    
    
    
    
    [self addSubview:self.pickerHours];
    
    
}

- (void) deletePickers{
   
    [self.pickerHours removeFromSuperview];
    [self.pickerMinutes removeFromSuperview];
     self.pickerHours = nil;
    self.pickerMinutes = nil;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 2;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    if(self.arrayData.count>0){
        if (component == 0) {
            return self.arrayData.count;
        } else {
            
            NSDictionary * dict = [self.arrayData objectAtIndex:[self.pickerHours selectedRowInComponent:0]];
            NSArray * array = [dict objectForKey:@"minutes"];
            
            return array.count;
            
        }
    }else{
        return 0;
    }
    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
                     forComponent:(NSInteger)component {
    
    
        if (component == 0) {
            NSDictionary * dict = [self.arrayData objectAtIndex:row];
            return [dict objectForKey:@"hours"];
        } else {
            NSDictionary * dict = [self.arrayData objectAtIndex:[self.pickerHours selectedRowInComponent:0]];
            NSArray * array = [dict objectForKey:@"minutes"];
            
            return [array objectAtIndex:row];
            
            
        }
        
    
    

}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
        if (component == 0) {
            [pickerView reloadAllComponents];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
        }
   
        NSString *  hours = [[self.arrayData objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"hours"];
        NSArray * minutes = [[self.arrayData objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"minutes"];
    
        NSString * minutesString = [minutes objectAtIndex:[pickerView selectedRowInComponent:1]];
    
        NSString * resultTime = [NSString stringWithFormat:@"%@:%@",hours,minutesString];
        [self.delegate setChooseTime:resultTime];
    
}

@end
