From: akpm@linux-foundation.org
Subject: - rtc-fm3130-fix-chip-naming.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:34:58 -0700
Message-ID: <200807141934.m6EJYwe4023848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535AbYGNTfV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, david-b@pacbell.net, slapin@ossfans.org, mm-commits@vger.kernel.org


The patch titled
     rtc-fm3130: fix chip naming
has been removed from the -mm tree.  Its filename was
     rtc-fm3130-fix-chip-naming.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-fm3130: fix chip naming
From: Alessandro Zummo <a.zummo@towertech.it>

Fix chip naming from fm3031-rtc to fm3031

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Sergey Lapin <slapin@ossfans.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-fm3130.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-fm3130.c~rtc-fm3130-fix-chip-naming drivers/rtc/rtc-fm3130.c
--- a/drivers/rtc/rtc-fm3130.c~rtc-fm3130-fix-chip-naming
+++ a/drivers/rtc/rtc-fm3130.c
@@ -55,7 +55,7 @@ struct fm3130 {
 	int			alarm;
 };
 static const struct i2c_device_id fm3130_id[] = {
-	{ "fm3130-rtc", 0 },
+	{ "fm3130", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, fm3130_id);
_

Patches currently in -mm which might be from a.zummo@towertech.it are

linux-next.patch
ntp-let-update_persistent_clock-sleep.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-m41t80-sort-header-inclusions-for-readability.patch
rtc-m41t80-use-pr_info-as-appropriate.patch
rtc-remove-bkl-for-ioctl.patch
rtc-add-support-for-st-m41t94-spi-rtc.patch
rtc-ds1305-ds1306-driver.patch
rtc-ds1305-ds1306-driver-fix.patch
rtc-bcd-codeshrink.patch
rtc-rtc-omap-footprint-shrinkage.patch
rtc-convert-the-pcf8583-driver-to-the-new-i2c-style-framework-with-device_ids.patch
rtc-marvell-soc-rtc-driver.patch

