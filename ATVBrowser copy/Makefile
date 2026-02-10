ARCHS = armv7
TARGET = iphone:clang:9.3:4.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SimpleApp

SimpleApp_FILES = Classes/SimpleAppliance.xm
SimpleApp_INSTALL_PATH = /Applications/Lowtide.app/Appliances
SimpleApp_BUNDLE_EXTENSION = frappliance
SimpleApp_FRAMEWORKS = Foundation UIKit
SimpleApp_PRIVATE_FRAMEWORKS = BackRow

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 AppleTV || true"
