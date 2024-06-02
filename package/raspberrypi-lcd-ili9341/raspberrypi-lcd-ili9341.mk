################################################################################
#
# raspberrypi-lcd-ili9341
#
################################################################################

RASPBERRYPI_LCD_ILI9341_DEPENDENCIES = host-dtc rpi-firmware

define RASPBERRYPI_LCD_ILI9341_EXTRACT_CMDS
	cp $(RASPBERRYPI_LCD_ILI9341_PKGDIR)/* $(@D)
endef

define RASPBERRYPI_LCD_ILI9341_BUILD_CMDS
	$(HOST_DIR)/bin/dtc -@ -I dts -O dtb -o $(@D)/rpi0wlcd.dtbo \
		$(@D)/rpi0wlcd.dts
endef

define RASPBERRYPI_LCD_ILI9341_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/rpi-firmware/overlays
	cp $(@D)/rpi0wlcd.dtbo \
		$(BINARIES_DIR)/rpi-firmware/overlays/rpi0wlcd.dtbo

	$(INSTALL) -D -m 0755 $(@D)/S50rpi0wlcd \
		$(TARGET_DIR)/etc/init.d/S50rpi0wlcd

	grep -q "dtoverlay=rpi0wlcd" \
		"$(BINARIES_DIR)/rpi-firmware/config.txt" || \
		printf "\n\x23 Enable ili9341 lcd\ndtoverlay=rpi0wlcd\n" \
		>> $(BINARIES_DIR)/rpi-firmware/config.txt

	grep -q "dtoverlay=vc4-fkms-v3d" \
		"$(BINARIES_DIR)/rpi-firmware/config.txt" || \
		printf "\n\x23 Force GPU driver\ndtoverlay=vc4-fkms-v3d\n" \
		>> $(BINARIES_DIR)/rpi-firmware/config.txt

	grep -q "fbcon=map:1" "$(BINARIES_DIR)/rpi-firmware/cmdline.txt" || \
		{ TXTLINE=$$(cat "$(BINARIES_DIR)/rpi-firmware/cmdline.txt"); \
		echo "$$TXTLINE fbcon=map:1" > \
		"$(BINARIES_DIR)/rpi-firmware/cmdline.txt"; }
endef

$(eval $(generic-package))
