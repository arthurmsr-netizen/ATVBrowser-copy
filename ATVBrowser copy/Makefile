ARCHS = armv7
TARGET = iphone:clang:9.3:4.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Browser

Browser_FILES = Classes/BrowserAppliance.xm Classes/BrowserController.xm Classes/BrowserWebView.xm Classes/SettingsController.xm Classes/UserProfileManager.xm
Browser_INSTALL_PATH = /Applications/Lowtide.app/Appliances
Browser_BUNDLE_EXTENSION = frappliance
Browser_FRAMEWORKS = Foundation UIKit
Browser_PRIVATE_FRAMEWORKS = BackRow

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 AppleTV || true"
