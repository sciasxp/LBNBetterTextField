//
//  LBNBetterTextField.h
//
//  Created by Luciano Bastos Nunes on 29/03/16.
//  Copyright © 2016 Tap4Mobile LTDA. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LengthType) {
    
    ValueNotSetType = -1
};

typedef NS_ENUM(NSInteger, ShakeDirection) {
    
    ShakeDirectionHorizontal,
    ShakeDirectionVertical
};

typedef BOOL (^ValidationBlock)(NSString *text);
typedef void (^ExecuteBlock)(UITextField *textField);

typedef NSString *(^FormatBlock)(UITextField *textField, NSString *string);
typedef BOOL(^TextFieldShouldReturnShouldChangeCharactersInRange)(UITextField *textField, NSRange range, NSString *replacementString);
typedef BOOL(^TextFieldShouldReturn)(UITextField *textField);
typedef void(^TextFieldDidBeginEditing)(UITextField *textField);
typedef void(^TextFieldDidEndEditing)(UITextField *textField);

IB_DESIGNABLE

@interface LBNBetterTextField : UITextField

@property (readwrite, nonatomic) NSInteger minLength;
@property (readwrite, nonatomic) NSInteger maxLength;
@property (readwrite, nonatomic) BOOL shakeOnNotValid;
@property (strong, nonatomic) ValidationBlock validation;
@property (strong, nonatomic) FormatBlock format;
@property (strong, nonatomic) IBInspectable UIColor *placeHolderTextColor;

- (void)addTextFieldShouldChangeCharactersInRangeWithBlock:(TextFieldShouldReturnShouldChangeCharactersInRange)block;
- (void)addTextFieldShouldReturnWithBlock:(TextFieldShouldReturn)block;
- (void)addTextFieldShouldBeginEditingWithBlock:(TextFieldShouldReturn)block;
- (void)addTextFieldDidBeginEditingWithBlock:(TextFieldDidBeginEditing)block;
- (void)addTextFieldDidEndEditingWithBlock:(TextFieldDidEndEditing)block;

- (void)addExecuteBlockOnFinish:(ExecuteBlock)block;

@end
