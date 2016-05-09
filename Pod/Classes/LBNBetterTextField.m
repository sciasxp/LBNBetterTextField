//
//  LBNBetterTextField.m
//
//  Created by Luciano Bastos Nunes on 29/03/16.
//  Copyright © 2016 Tap4Mobile LTDA. All rights reserved.
//

#import "LBNBetterTextField.h"

#pragma mark - UITextFieldProxyDelegate

@interface UITextFieldProxyDelegate : NSObject <UITextFieldDelegate>

@property (strong, nonatomic) TextFieldShouldReturnShouldChangeCharactersInRange shouldReturnShouldChangeCharactersInRangeBlock;
@property (strong, nonatomic) TextFieldShouldReturn shouldReturnBlock;
@property (strong, nonatomic) TextFieldShouldReturn shouldBeginEditingBlock;
@property (strong, nonatomic) TextFieldDidBeginEditing didBeginEditingBlock;
@property (strong, nonatomic) TextFieldDidEndEditing didEndEditingBlock;

@property (readwrite, nonatomic) NSInteger minLength;
@property (readwrite, nonatomic) NSInteger maxLength;
@property (readwrite, nonatomic) BOOL shakeOnNotValid;
@property (strong, nonatomic) ValidationBlock validation;
@property (strong, nonatomic) FormatBlock format;
@property (strong, nonatomic) ExecuteBlock execute;

@property (weak, nonatomic) UITextField *textField;

@property (readwrite, nonatomic) BOOL textFieldReturned;

@end

@implementation UITextFieldProxyDelegate

- (instancetype)init {
    if (self = [super init])
    {
        self.textFieldReturned = NO;
    }
    
    return self;
}

#pragma mark - Private Methods

- (void)shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta speed:(NSTimeInterval)interval shakeDirection:(ShakeDirection)shakeDirection completion:(nullable void (^)())handler {
    
    [UIView animateWithDuration:interval animations:^{
        
        self.textField.transform = (shakeDirection == ShakeDirectionHorizontal) ? CGAffineTransformMakeTranslation(delta * direction, 0) : CGAffineTransformMakeTranslation(0, delta * direction);
        
    } completion:^(BOOL finished) {
        
        if(current >= times) {
            [UIView animateWithDuration:interval animations:^{
                self.textField.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (handler) {
                    handler();
                }
            }];
            return;
        }
        
        [self shake:(times - 1)
          direction:direction * -1
       currentTimes:current + 1
          withDelta:delta
              speed:interval
     shakeDirection:shakeDirection
         completion:handler];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL defaultReturnValue = YES;
    
    if (self.maxLength > ValueNotSetType) {
        
        if (string.length == 0) {
            
            return YES;
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newString.length > self.maxLength) {
            
            if (self.shakeOnNotValid) {
                
                [self shake:10 direction:ShakeDirectionVertical currentTimes:0 withDelta:5 speed:0.05 shakeDirection:ShakeDirectionVertical completion:nil];
            }
            
            return NO;
        }
    }
    
    if (self.format) {
        
        NSString *newString = self.format(textField, string);
        textField.text = newString;
        return NO;
    }
    
    if (self.shouldReturnShouldChangeCharactersInRangeBlock)
    {
        defaultReturnValue = self.shouldReturnShouldChangeCharactersInRangeBlock(textField, range, string);
        
        if (!defaultReturnValue) {
            
            if (self.shakeOnNotValid) {
                
                [self shake:10 direction:ShakeDirectionVertical currentTimes:0 withDelta:5 speed:0.05 shakeDirection:ShakeDirectionVertical completion:nil];
            }
        }
    }
    
    return defaultReturnValue;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL defaultReturnValue = YES;
    self.textFieldReturned = YES;
    
    if (self.minLength > ValueNotSetType) {
        
        if (textField.text.length < self.minLength) {
            
            if (self.shakeOnNotValid) {
                
                [self shake:10 direction:ShakeDirectionVertical currentTimes:0 withDelta:5 speed:0.05 shakeDirection:ShakeDirectionVertical completion:nil];
            }
            
            return NO;
        }
    }
    
    if (self.validation) {
        
        if (self.validation(textField.text) == NO) {
            
            if (self.shakeOnNotValid) {
                
                [self shake:10 direction:ShakeDirectionVertical currentTimes:0 withDelta:5 speed:0.05 shakeDirection:ShakeDirectionVertical completion:nil];
            }
            
            defaultReturnValue = NO;
        }
    }
    
    if (self.shouldReturnBlock)
    {
        if (defaultReturnValue) {
            
            defaultReturnValue = self.shouldReturnBlock(textField);
            
        } else {
            
            if (self.shakeOnNotValid) {
                
                [self shake:10 direction:ShakeDirectionVertical currentTimes:0 withDelta:5 speed:0.05 shakeDirection:ShakeDirectionVertical completion:nil];
            }
        }
    }
    
    if (defaultReturnValue) {
        
        if (self.execute) {
            
            self.execute(textField);
        }
    }
    
    return defaultReturnValue;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL defaultReturnValue = YES;
    
    if (self.shouldBeginEditingBlock)
    {
        defaultReturnValue = self.shouldBeginEditingBlock(textField);
    }
    
    return defaultReturnValue;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.didBeginEditingBlock)
    {
        self.didBeginEditingBlock(textField);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textFieldReturned) {
        
        self.textFieldReturned = NO;
        return;
    }
    
    if (self.didEndEditingBlock)
    {
        BOOL defaultReturnValue = YES;
        
        if (self.minLength > ValueNotSetType) {
            
            if (textField.text.length < self.minLength) {
                
                if (self.shakeOnNotValid) {
                    
                    [self shake:10 direction:ShakeDirectionVertical currentTimes:0 withDelta:5 speed:0.05 shakeDirection:ShakeDirectionVertical completion:nil];
                }
                
                defaultReturnValue = NO;
            }
        }
        
        if (self.validation) {
            
            if (defaultReturnValue) {
                
                if (self.validation(textField.text) == NO) {
                    
                    if (self.shakeOnNotValid) {
                        
                        [self shake:10 direction:ShakeDirectionVertical currentTimes:0 withDelta:5 speed:0.05 shakeDirection:ShakeDirectionVertical completion:nil];
                    }
                    
                    defaultReturnValue = NO;
                }
            }
        }
        
        if (defaultReturnValue) {
            
            self.didEndEditingBlock(textField);
            
        } else {
            
            if (self.shakeOnNotValid) {
                
                [self shake:10 direction:ShakeDirectionVertical currentTimes:0 withDelta:5 speed:0.05 shakeDirection:ShakeDirectionVertical completion:nil];
            }
        }
        
        if (defaultReturnValue) {
            
            if (self.execute) {
                
                self.execute(textField);
            }
        }
    }
}

@end

#pragma mark - LBNBetterTextField

@interface LBNBetterTextField ()

@property (strong, nonatomic) UITextFieldProxyDelegate *proxyDelegate;

@end

@implementation LBNBetterTextField

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    /*
     [self.placeHolderTextColor setFill];
     [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeTailTruncation alignment:self.textAlignment];
     */
    
    if (self.placeHolderTextColor) {
        
        self.attributedPlaceholder = [[NSAttributedString alloc]
                                      initWithString:self.placeholder
                                      attributes:@{NSForegroundColorAttributeName:self.placeHolderTextColor}];
    }
}

#pragma mark - Init Methods

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        [self commonInit];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if ( self )
    {
        [self commonInit];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if ( self )
    {
        [self commonInit];
    }
    return self;
}

#pragma mark - Setter/Getter

- (void)setMinLength:(NSInteger)minLength {
    
    _minLength = minLength;
    self.proxyDelegate.minLength = minLength;
}

- (void)setMaxLength:(NSInteger)maxLength {
    
    _maxLength = maxLength;
    self.proxyDelegate.maxLength = maxLength;
}

- (void)setShakeOnNotValid:(BOOL)shakeOnNotValid {
    
    _shakeOnNotValid = shakeOnNotValid;
    self.proxyDelegate.shakeOnNotValid = shakeOnNotValid;
}

- (void)setFormat:(FormatBlock)format {
    
    _format = format;
    self.proxyDelegate.format = format;
}

- (void)setValidation:(ValidationBlock)validation {
    
    _validation = validation;
    self.proxyDelegate.validation = validation;
}

#pragma mark - Override Methods

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    
    NSAssert([delegate isKindOfClass:[UITextFieldProxyDelegate class]], @"This class will handle its own delegate.");
    
    super.delegate = delegate;
}

#pragma mark - Private Methods

- (void)commonInit {
    
    [self checkAndSetDelegate];
    
    self.minLength = ValueNotSetType;
    self.maxLength = ValueNotSetType;
    self.shakeOnNotValid = NO;
}

- (void)checkAndSetDelegate
{
    if (!self.delegate)
    {
        self.proxyDelegate = [[UITextFieldProxyDelegate alloc] init];
        self.proxyDelegate.textField = self;
        self.delegate = self.proxyDelegate;
    }
}

#pragma mark - Public Methods

- (void)addTextFieldShouldChangeCharactersInRangeWithBlock:(TextFieldShouldReturnShouldChangeCharactersInRange)block;
{
    [self checkAndSetDelegate];
    self.proxyDelegate.shouldReturnShouldChangeCharactersInRangeBlock = block;
}

- (void)addTextFieldShouldReturnWithBlock:(TextFieldShouldReturn)block
{
    [self checkAndSetDelegate];
    self.proxyDelegate.shouldReturnBlock = block;
}

- (void)addTextFieldShouldBeginEditingWithBlock:(TextFieldShouldReturn)block
{
    [self checkAndSetDelegate];
    self.proxyDelegate.shouldBeginEditingBlock = block;
}

- (void)addTextFieldDidBeginEditingWithBlock:(TextFieldDidBeginEditing)block
{
    [self checkAndSetDelegate];
    self.proxyDelegate.didBeginEditingBlock = block;
}

- (void)addTextFieldDidEndEditingWithBlock:(TextFieldDidEndEditing)block
{
    [self checkAndSetDelegate];
    self.proxyDelegate.didEndEditingBlock = block;
}

- (void)addExecuteBlockOnFinish:(ExecuteBlock)block {
    
    [self checkAndSetDelegate];
    self.proxyDelegate.execute = block;
}

@end
