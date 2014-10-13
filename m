From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:38:17 -0700
Message-ID: <543c5459.VTxjVG7N9xAdsbSe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJMWiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch

This patch was dropped because it was folded into rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes

WARNING: braces {} are not necessary for single statement blocks
#115: FILE: drivers/rtc/rtc-bq32k.c:217:
+	if (client && client->dev.of_node) {
+		trickle_charger_of_init(dev, client->dev.of_node);
+	}

total: 0 errors, 1 warnings, 93 lines checked

./patches/rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bq32k.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-bq32k.c~rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes drivers/rtc/rtc-bq32k.c
--- a/drivers/rtc/rtc-bq32k.c~rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes
+++ a/drivers/rtc/rtc-bq32k.c
@@ -214,9 +214,8 @@ static int bq32k_probe(struct i2c_client
 	if (error)
 		return error;
 
-	if (client && client->dev.of_node) {
+	if (client && client->dev.of_node)
 		trickle_charger_of_init(dev, client->dev.of_node);
-	}
 
 	rtc = devm_rtc_device_register(&client->dev, bq32k_driver.driver.name,
 						&bq32k_rtc_ops, THIS_MODULE);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch

