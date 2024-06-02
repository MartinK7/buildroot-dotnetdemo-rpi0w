################################################################################
#
# dotnetdemo
#
################################################################################

DOTNETDEMO_VERSION = v1.0.0
DOTNETDEMO_SITE = https://github.com/MartinK7/dotnetdemo.git
DOTNETDEMO_SITE_METHOD = git
DOTNETDEMO_LICENSE = MIT
DOTNETDEMO_DEPENDENCIES = host-mono mono

define DOTNETDEMO_BUILD_CMDS
	$(HOST_DIR)/bin/xbuild /p:Configuration=Release \
		$(@D)/dotnetdemo/dotnetdemo.csproj
endef

define DOTNETDEMO_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/dotnetdemo
	$(INSTALL) -D -m 0755 \
		$(@D)/dotnetdemo/bin/Release/dotnetdemo.exe \
		$(TARGET_DIR)/usr/share/dotnetdemo/dotnetdemo-$(DOTNETDEMO_VERSION).exe
endef

$(eval $(generic-package))
