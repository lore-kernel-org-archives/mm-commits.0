From: akpm@linux-foundation.org
Subject: - rtc-isl1208-fixes-double-removal-of-a-sysfs-entry.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:25 -0700
Message-ID: <200808130852.m7D8qPhu008204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754297AbYHMIxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.zummo@towertech.it, david-b@pacbell.net, hartleys@visionengravers.com, hvr@gnu.org, mm-commits@vger.kernel.org


The patch titled
     rtc-isl1208: fix double removal of a sysfs entry
has been removed from the -mm tree.  Its filename was
     rtc-isl1208-fixes-double-removal-of-a-sysfs-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-isl1208: fix double removal of a sysfs entry
From: Alessandro Zummo <a.zummo@towertech.it>

Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Herbert Valerio Riedel <hvr@gnu.org>
Cc: Hartley Sweeten <hartleys@visionengravers.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-isl1208.c~rtc-isl1208-fixes-double-removal-of-a-sysfs-entry drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~rtc-isl1208-fixes-double-removal-of-a-sysfs-entry
+++ a/drivers/rtc/rtc-isl1208.c
@@ -482,7 +482,7 @@ isl1208_sysfs_register(struct device *de
 static int
 isl1208_sysfs_unregister(struct device *dev)
 {
-	device_remove_file(dev, &dev_attr_atrim);
+	device_remove_file(dev, &dev_attr_dtrim);
 	device_remove_file(dev, &dev_attr_atrim);
 	device_remove_file(dev, &dev_attr_usr);
 
_

Patches currently in -mm which might be from a.zummo@towertech.it are

ntp-let-update_persistent_clock-sleep.patch
rtc-rtc-ds1374-fix-no-irq-case-handling.patch
rtc-bunch-of-drivers-fix-no-irq-case-handing.patch
rtc-pcf8563-remove-client-validation.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-ds1374-wakup-support.patch
rtc-ds1374-wakeup-support-update.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch
rtc-remove-some-nop-open-release-methods.patch
legacy-rtc-remove-needless-confusing-hpet_rtc_irq-option.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c372-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-file-close-consistently-disables-repeating-irqs.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch

