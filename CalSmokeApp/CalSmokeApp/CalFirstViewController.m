#import "CalFirstViewController.h"
#import "UIView+Positioning.h"
#import "CalViewWithArbitrarySelectors.h"

static NSString *const kUserDefaultsSwitchState = @"sh.calaba.CalSmokeApp Switch State";

typedef enum : NSInteger {
  kTagTextField = 3030,
  kTagSwitch
} view_tags;

@interface CalFirstView : CalViewWithArbitrarySelectors <UITextFieldDelegate>

@property (nonatomic, readonly, strong) UITextField *textField;
@property (nonatomic, readonly, strong) IBOutlet UISwitch *uiswitch;

- (void) switchValueChanged:(UISwitch *) sender;

@end

@implementation CalFirstView

@synthesize textField = _textField;
@synthesize uiswitch = _uiswitch;

- (id) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.accessibilityIdentifier = @"first page";
    self.accessibilityLabel = NSLocalizedString(@"First page", @"ACCESSIBILITY: the first page");
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

#pragma - Subviews

- (UITextField *) textField {
  if (_textField) { return _textField; }
  UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
  textField.accessibilityIdentifier = @"text";
  textField.accessibilityLabel = NSLocalizedString(@"Text field", @"ACCESSIBILITY a text field");
  textField.tag = kTagTextField;
  textField.borderStyle = UITextBorderStyleLine;
  textField.clearsOnBeginEditing = NO;
  textField.clearsOnInsertion = NO;
  textField.clearButtonMode = UITextFieldViewModeAlways;
  textField.returnKeyType = UIReturnKeyDone;
  textField.delegate = self;
  _textField = textField;
  return _textField;
}

- (UISwitch *) uiswitch {
  if (_uiswitch) { return _uiswitch; }

  CGRect frame = CGRectMake(0, 0, 64, 44);
  _uiswitch = [[UISwitch alloc] initWithFrame:frame];

  _uiswitch.tag = kTagSwitch;
  _uiswitch.accessibilityIdentifier = @"switch";
  _uiswitch.accessibilityLabel = @"On off switch";
  [_uiswitch addTarget:self
                action:@selector(switchValueChanged:)
      forControlEvents:UIControlEventValueChanged];

  return _uiswitch;
}

- (void) layoutSubviews {
  UITextField *existingTextField = (UITextField *)[self viewWithTag:kTagTextField];
  NSString *existingText = nil;
  if (existingTextField) {
    existingText = existingTextField.text;
    [existingTextField removeFromSuperview];
    _textField = nil;
  }

  UITextField *textField = [self textField];

  CGFloat x = 20;
  CGFloat y = 64;
  CGFloat height = 28;
  CGFloat width = self.width - 40;
  textField.frame = CGRectMake(x, y, width, height);
  textField.text = existingText;
  textField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
  [self addSubview:textField];

  UISwitch *existingSwitch = (UISwitch *)[self viewWithTag:kTagSwitch];
  if (existingSwitch) {
    [existingSwitch removeFromSuperview];
    _uiswitch = nil;
  }

  UISwitch *newSwitch = [self uiswitch];
  newSwitch.center = self.center;

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL lastSwitchState = [defaults boolForKey:kUserDefaultsSwitchState];
  [newSwitch setOn:lastSwitchState];
  [self addSubview:newSwitch];
}

#pragma  mark Text Field Delegate

- (void) textFieldDidBeginEditing:(UITextField *) aTextField {

}

- (void) textFieldDidEndEditing:(UITextField *) aTextField {

}

- (BOOL) textFieldShouldClear:(UITextField *) aTextField {
  return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *) aTextField {
  [aTextField resignFirstResponder];
  return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *) aTextField {
  return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *) aTextField {
  return YES;
}

- (BOOL) textField:(UITextField *) aTextField shouldChangeCharactersInRange:(NSRange) aRange replacementString:(NSString *) aString {
  return YES;
}

#pragma mark - Actions

- (void) switchValueChanged:(UISwitch *) sender {
  NSLog(@"switch value changed");
  BOOL state = sender.isOn;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:state forKey:kUserDefaultsSwitchState];
  [defaults synchronize];
}

@end

@implementation CalFirstViewController

#pragma mark - Memory Management

- (instancetype) init {
  self = [super init];
  if (self){
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
  }
  return self;
}

- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark View Lifecycle

- (void) loadView {
  CGRect frame = [[UIScreen mainScreen] applicationFrame];
  CalFirstView *view = [[CalFirstView alloc] initWithFrame:frame];
  
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view = view;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL lastSwitchState = [defaults boolForKey:kUserDefaultsSwitchState];
  CalFirstView *view = (CalFirstView *)self.view;
  [view.uiswitch setOn:lastSwitchState];

  /*
   NSLog(@"Text input Capitalization Types");
   NSLog(@"     none = %@", @(UITextAutocapitalizationTypeNone));
   NSLog(@"    words = %@", @(UITextAutocapitalizationTypeWords));
   NSLog(@"sentences = %@", @(UITextAutocapitalizationTypeSentences));
   NSLog(@"      all = %@", @(UITextAutocapitalizationTypeAllCharacters));

   NSLog(@"Text input Correction Types");
   NSLog(@"  default = %@", @(UITextAutocorrectionTypeDefault));
   NSLog(@"       no = %@", @(UITextAutocorrectionTypeNo));
   NSLog(@"      yes = %@", @(UITextAutocorrectionTypeYes));

   NSLog(@"Text input Spell Checking Types");
   NSLog(@"  default = %@", @(UITextSpellCheckingTypeDefault));
   NSLog(@"       no = %@", @(UITextSpellCheckingTypeNo));
   NSLog(@"      yes = %@", @(UITextSpellCheckingTypeYes));
 */

  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

@end
