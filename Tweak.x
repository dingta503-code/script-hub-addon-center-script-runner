#import <UIKit/UIKit.h>
#import <substrate.h>

// --- [ 1. ส่วนแก้ Error สำหรับ iOS 13+ ] ---
UIWindow *get_keyWindow() {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) return window;
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

// --- [ 2. ส่วนฟังก์ชัน UI และ ESP ของคุณ ] ---
// ผมเตรียมช่องไว้ให้ใส่ Logic เดิมของคุณตรงนี้ครับ
void setupHyperXMenu() {
    // ใส่ Logic การสร้างปุ่ม หรือ UI ของคุณที่นี่
    NSLog(@"[Hyper! X Store] UI Menu Initialized");
}

void applyBypass() {
    // ใส่ Logic การ Bypass หรือ Patch Memory ตรงนี้
    // ตัวอย่าง: MSHookMemory((void *)(0x100000000 + 0x123456), "\x20\x00\x80\xD2", 4);
    NSLog(@"[Hyper! X Store] Bypass Applied");
}

// --- [ 3. ส่วนการทำงานหลัก (Hook) ] ---
%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // ตรวจสอบว่าหน้าจอพร้อมหรือยัง
        UIWindow *window = get_keyWindow();
        if (window) {
            // รันฟังก์ชันทั้งหมดที่เตรียมไว้
            applyBypass();
            setupHyperXMenu();
            
            // แสดงแจ้งเตือนตอนเข้าเกม
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hyper! X Store" 
                                        message:@"ระบบพร้อมใช้งานแล้ว!" 
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"ตกลง" style:UIAlertActionStyleDefault handler:nil]];
            [[window rootViewController] presentViewController:alert animated:YES completion:nil];
        }
    });
}

%end
