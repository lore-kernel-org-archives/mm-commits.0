From: akpm@linux-foundation.org
Subject: + rtc-fm3130-fix-chip-naming.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:57:01 -0700
Message-ID: <200807120057.m6C0v14Z013361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754113AbYGLA5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:57:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.zummo@towertech.it, david-b@pacbell.net, slapin@ossfans.org


The patch titled
     rtc-fm3130: fix chip naming
has been added to the -mm tree.  Its filename is
     rtc-fm3130-fix-chip-naming.patch

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

rtc-fm3130-fix-chip-naming.patch
rtc-pcf8563-add-chip-id.patch
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

