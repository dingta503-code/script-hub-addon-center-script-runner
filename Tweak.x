#import <UIKit/UIKit.h>
#import <substrate.h>
#import <mach-o/dyld.h>

// ==========================================
// 1. ตัวแปรควบคุมฟังก์ชัน (Global Variables)
// ==========================================
static BOOL isESPActive = NO;
static BOOL isSilentAim = NO;
static BOOL isAntiCap = YES; // เปิดไว้ก่อนเพื่อความปลอดภัย

// ==========================================
// 2. ส่วนของ UI (Hyper! X Store Menu)
// ==========================================
@interface HyperXMenu : UIView
@property (nonatomic, strong) UIView *menuWindow;
@end

@implementation HyperXMenu

static HyperXMenu *instance;

// โหลดเมนูหลังจากเข้าเกมไปแล้ว 5 วินาที
+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        instance = [[HyperXMenu alloc] init];
        [instance setupMenu];
    });
}

- (void)setupMenu {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    // --- ระบบ Anti-Screen Capture (ซ่อนเมนูจากวิดีโออัดหน้าจอ) ---
    UITextField *secureField = [[UITextField alloc] init];
    secureField.secureTextEntry = YES;
    UIView *secureContainer = secureField.subviews.firstObject;
    secureContainer.userInteractionEnabled = YES;
    secureContainer.frame = CGRectMake(50, 100, 240, 200);
    
    // --- ตัวหน้าต่างเมนู ---
    _menuWindow = [[UIView alloc] initWithFrame:secureContainer.bounds];
    _menuWindow.backgroundColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:0.95];
    _menuWindow.layer.borderColor = [UIColor greenColor].CGColor;
    _menuWindow.layer.borderWidth = 2.0;
    _menuWindow.layer.cornerRadius = 12;
    
    // หัวข้อเมนู
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 240, 30)];
    title.text = @"HYPER! X STORE";
    title.textColor = [UIColor greenColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18];
    [_menuWindow addSubview:title];

    // ปุ่มเปิด/ปิด ESP
    UIButton *espBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    espBtn.frame = CGRectMake(20, 60, 200, 45);
    espBtn.backgroundColor = [UIColor darkGrayColor];
    espBtn.layer.cornerRadius = 8;
    [espBtn setTitle:@"ESP: OFF" forState:UIControlStateNormal];
    [espBtn addTarget:self action:@selector(toggleESP:) forControlEvents:UIControlEventTouchUpInside];
    [_menuWindow addSubview:espBtn];

    // ปุ่มเปิด/ปิด Silent Aim
    UIButton *aimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aimBtn.frame = CGRectMake(20, 120, 200, 45);
    aimBtn.backgroundColor = [UIColor darkGrayColor];
    aimBtn.layer.cornerRadius = 8;
    [aimBtn setTitle:@"Silent Aim: OFF" forState:UIControlStateNormal];
    [aimBtn addTarget:self action:@selector(toggleAim:) forControlEvents:UIControlEventTouchUpInside];
    [_menuWindow addSubview:aimBtn];

    [secureContainer addSubview:_menuWindow];
    [keyWindow addSubview:secureContainer];

    // ทำให้เมนูเลื่อนไปมาได้ (Pan Gesture)
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_menuWindow addGestureRecognizer:pan];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    UIView *view = sender.view.superview; // เลื่อนที่ตัว Container
    CGPoint translation = [sender translationInView:view.superview];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [sender setTranslation:CGPointZero inView:view.superview];
}

- (void)toggleESP:(UIButton *)sender {
    isESPActive = !isESPActive;
    [sender setTitle:isESPActive ? @"ESP: ON" : @"ESP: OFF" forState:UIControlStateNormal];
    sender.backgroundColor = isESPActive ? [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0] : [UIColor darkGrayColor];
}

- (void)toggleAim:(UIButton *)sender {
    isSilentAim = !isSilentAim;
    [sender setTitle:isSilentAim ? @"Aim: ON" : @"Aim: OFF" forState:UIControlStateNormal];
    sender.backgroundColor = isSilentAim ? [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0] : [UIColor darkGrayColor];
}

@end

// ==========================================
// 3. ระบบ Stealth & Bypass (Anti-Detection)
// ==========================================

// Bypass การเช็คว่ามีไฟล์ dylib ของเราอยู่ในเครื่องไหม
int (*old_access)(const char *path, int mode);
int new_access(const char *path, int mode) {
    if (path != NULL && (strstr(path, "HyperX") || strstr(path, ".dylib"))) {
        return -1; // หลอกว่าหาไฟล์ไม่เจอ
    }
    return old_access(path, mode);
}

// ==========================================
// 4. ส่วนการทำงานเบื้องหลัง (Injection)
// ==========================================
%ctor {
    // 1. ทำการ Bypass ทันทีที่โหลด
    MSHookFunction((void *)access, (void *)new_access, (void **)&old_access);

    // 2. แสดง Log ใน Console (เอาไว้เช็คว่า dylib ทำงานไหม)
    NSLog(@"[Hyper! X Store] dylib Successfully Injected!");
}
