From: akpm@linux-foundation.org
Subject: + rtc-pcf8583-build-fix.patch added to -mm tree
Date: Thu, 17 Apr 2008 13:58:35 -0700
Message-ID: <200804172058.m3HKwZe3027664@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752782AbYDQU7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 16:59:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, bunk@kernel.org, stable@kernel.org


The patch titled
     rtc-pcf8583 build fix
has been added to the -mm tree.  Its filename is
     rtc-pcf8583-build-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-pcf8583 build fix
From: David Brownell <dbrownell@users.sourceforge.net>

Fix bogus #include in rtc-pcf8583, so it compiles on platforms that
don't support PC clone RTCs.  (Original issue noted by Adrian Bunk.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8583.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-build-fix drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-build-fix
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -15,7 +15,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/mc146818rtc.h>
+#include <linux/rtc.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/bcd.h>
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

rtc-pcf8583-build-fix.patch
git-acpi.patch
git-alsa-tiwai.patch
git-arm.patch
git-avr32.patch
macintosh-windfarm-fix-platform-driver-hotplug-coldplug.patch
git-input.patch
input-fix-platform-driver-hotplug-coldplug.patch
ata-ide-fix-platform-driver-hotplug-coldplug.patch
mtd-maps-fix-platform-driver-hotplug-coldplug.patch
mtd-nand-fix-platform-driver-hotplug-coldplug.patch
net-drivers-fix-platform-driver-hotplug-coldplug.patch
scsi-fix-platform-driver-hotplug-coldplug.patch
spi-use-menuconfig-for-config_spi.patch
spi-pxa2xx_spi-sparse-fixes.patch
documentation-move-spidev_fdx-example-to-its-own-source-file.patch
spi-replace-remaining-__function__-occurrences.patch
spi-spi_imx-updates.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
kerneldoc-for-linux-clkh.patch
kerneldoc-for-linux-clkh-fix.patch
rtc-add-the-support-for-alarm-time-relative-to-current-time-in-sysfs.patch
gpiolib-better-rmmod-infrastructure.patch
gpiolib-i2c-spi-drivers-handle-rmmod-better.patch
gpio-define-gpio_is_valid.patch
gpiolib-dynamic-gpio-number-allocation.patch
gpiochip_reserve.patch
gpiochip_reserve-fix.patch
gpiochip_reserve-fix-2.patch
atmel_lcdfb-suspend-resume-support.patch
atmel_lcdfb-wiring-bgr-to-rgb-color-mode.patch
usb-gadget-switch-to-put_char-returning-int.patch
mmc-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
omap_rng-minor-updates.patch

