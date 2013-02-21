From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:29:47 -0800
Message-ID: <20130221232947.6417C5A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:59190 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab3BUX3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:29:48 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so11413yhz.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:29:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, torbenh@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch

This patch was dropped because it was folded into rtc-add-support-for-spi-rtc-rx4581.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes

WARNING: quoted string split across lines
#171: FILE: drivers/rtc/rtc-rx4581.c:126:
+				dev_err(dev, "Unable to write device "
+					"flags\n");

WARNING: quoted string split across lines
#214: FILE: drivers/rtc/rtc-rx4581.c:169:
+	dev_dbg(dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
+		"mday=%d, mon=%d, year=%d, wday=%d\n",

WARNING: quoted string split across lines
#233: FILE: drivers/rtc/rtc-rx4581.c:188:
+	dev_dbg(dev, "%s: secs=%d, mins=%d, hours=%d, "
+		"mday=%d, mon=%d, year=%d, wday=%d\n",

WARNING: Using __devinit is unnecessary
#310: FILE: drivers/rtc/rtc-rx4581.c:265:
+static int __devinit rx4581_probe(struct spi_device *spi)

WARNING: Using __devexit is unnecessary
#329: FILE: drivers/rtc/rtc-rx4581.c:284:
+static int __devexit rx4581_remove(struct spi_device *spi)

WARNING: space prohibited between function name and open parenthesis '('
#355: FILE: drivers/rtc/rtc-rx4581.c:310:
+MODULE_DESCRIPTION ("rx4581 spi RTC driver");

WARNING: space prohibited between function name and open parenthesis '('
#356: FILE: drivers/rtc/rtc-rx4581.c:311:
+MODULE_AUTHOR ("Torben Hohn");

WARNING: space prohibited between function name and open parenthesis '('
#357: FILE: drivers/rtc/rtc-rx4581.c:312:
+MODULE_LICENSE ("GPL");

total: 0 errors, 8 warnings, 334 lines checked

./patches/rtc-add-support-for-spi-rtc-rx4581.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Torben Hohn <torbenh@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rx4581.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-rx4581.c~rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes drivers/rtc/rtc-rx4581.c
--- a/drivers/rtc/rtc-rx4581.c~rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes
+++ a/drivers/rtc/rtc-rx4581.c
@@ -262,7 +262,7 @@ static const struct rtc_class_ops rx4581
 	.set_time	= rx4581_set_datetime,
 };
 
-static int __devinit rx4581_probe(struct spi_device *spi)
+static int rx4581_probe(struct spi_device *spi)
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
@@ -281,7 +281,7 @@ static int __devinit rx4581_probe(struct
 	return 0;
 }
 
-static int __devexit rx4581_remove(struct spi_device *spi)
+static int rx4581_remove(struct spi_device *spi)
 {
 	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
 
@@ -307,7 +307,7 @@ static struct spi_driver rx4581_driver =
 
 module_spi_driver(rx4581_driver);
 
-MODULE_DESCRIPTION ("rx4581 spi RTC driver");
-MODULE_AUTHOR ("Torben Hohn");
-MODULE_LICENSE ("GPL");
+MODULE_DESCRIPTION("rx4581 spi RTC driver");
+MODULE_AUTHOR("Torben Hohn");
+MODULE_LICENSE("GPL");
 MODULE_ALIAS("spi:rtc-rx4581");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
goldfish-framebuffer-driver-fix.patch
ocfs2-remove-kfree-redundant-null-checks.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sys_prctl-coding-style-cleanup.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
rtc-max77686-add-maxim-77686-driver.patch
rtc-pcf8523-add-low-battery-voltage-support.patch
rtc-add-rtc-driver-for-tps80031-tps80032.patch
rtc-add-support-for-spi-rtc-rx4581.patch

