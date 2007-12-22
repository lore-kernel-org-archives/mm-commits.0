From: akpm@linux-foundation.org
Subject: + pcmcia-remove-pxa2xx_lubbock-build-warning.patch added to -mm tree
Date: Fri, 21 Dec 2007 20:50:04 -0800
Message-ID: <200712220450.lBM4o4f0017746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbXLVEuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 23:50:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     pcmcia: remove pxa2xx_lubbock build warning
has been added to the -mm tree.  Its filename is
     pcmcia-remove-pxa2xx_lubbock-build-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: remove pxa2xx_lubbock build warning
From: David Brownell <david-b@pacbell.net>

Init section confusion.  There will likely be some other similar
issues, introduced by I'm-not-sure-what-patch.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/pxa2xx_lubbock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/pxa2xx_lubbock.c~pcmcia-remove-pxa2xx_lubbock-build-warning drivers/pcmcia/pxa2xx_lubbock.c
--- a/drivers/pcmcia/pxa2xx_lubbock.c~pcmcia-remove-pxa2xx_lubbock-build-warning
+++ a/drivers/pcmcia/pxa2xx_lubbock.c
@@ -213,7 +213,7 @@ static struct pcmcia_low_level lubbock_p
 
 #include "pxa2xx_base.h"
 
-int __init pcmcia_lubbock_init(struct sa1111_dev *sadev)
+int pcmcia_lubbock_init(struct sa1111_dev *sadev)
 {
 	int ret = -ENODEV;
 
_

Patches currently in -mm which might be from david-b@pacbell.net are

pcmcia-remove-pxa2xx_lubbock-build-warning.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-arm.patch
git-input.patch
git-mmc.patch
git-mtd.patch
pcmcia-stop-updating-dev-powerpower_state.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
w1-gpio-add-gpio-w1-bus-master-driver.patch
spi-core-stop-updating-dev-powerpower_state.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
rtc-cmos-alarm-acts-as-oneshot.patch
platform-real-time-clock-driver-for-dallas-1511-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-fix.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
generic-gpio-gpio_chip-support-gpiolib-locking-simplified.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
arm-pxa-gpiolib-support-make-pxa_gpio_chip-static.patch
