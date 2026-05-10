#import <UIKit/UIKit.h>

// --- 1. ฟังก์ชันช่วยหาหน้าจอ (เพื่อให้ Build ผ่าน) ---
UIWindow *get_keyWindow() {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

// --- 2. วางโค้ด UI / Bypass / มองทะลุ (ESP) ของคุณตรงนี้ ---
// ก๊อปปี้พวก void setupMenu() หรือฟังก์ชันโกงของคุณมาวางได้เลย
// ------------------------------------------------------


%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWindow *window = get_keyWindow();
        if (window) {
            // --- 3. เรียกใช้ฟังก์ชันเปิดเมนูของคุณที่นี่ ---
            // เช่น [YourMenuClass showMenu]; หรือ setupUI();
            // ---------------------------------------
            NSLog(@"[Hyper! X Store] UI & Bypass Loaded!");
        }
    });
}

%end
