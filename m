From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-rk808-add-rtc-driver-for-rk808-fix.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 15:37:26 -0700
Message-ID: <543c5426.PdMKwAgQaWKWcUMS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaJMWh0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:37:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, zyw@rock-chips.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-rk808-add-rtc-driver-for-rk808-fix
has been removed from the -mm tree.  Its filename was
     rtc-rk808-add-rtc-driver-for-rk808-fix.patch

This patch was dropped because it was folded into rtc-rk808-add-rtc-driver-for-rk808.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-rk808-add-rtc-driver-for-rk808-fix

make tm_def static

Cc: Chris Zhong <zyw@rock-chips.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rk808.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-rk808.c~rtc-rk808-add-rtc-driver-for-rk808-fix drivers/rtc/rtc-rk808.c
--- a/drivers/rtc/rtc-rk808.c~rtc-rk808-add-rtc-driver-for-rk808-fix
+++ a/drivers/rtc/rtc-rk808.c
@@ -326,14 +326,14 @@ static SIMPLE_DEV_PM_OPS(rk808_rtc_pm_op
 	rk808_rtc_suspend, rk808_rtc_resume);
 
 /* 2014.1.1 12:00:00 Saturday */
-struct rtc_time tm_def = {
-			.tm_wday = 6,
-			.tm_year = 114,
-			.tm_mon = 0,
-			.tm_mday = 1,
-			.tm_hour = 12,
-			.tm_min = 0,
-			.tm_sec = 0,
+static struct rtc_time tm_def = {
+	.tm_wday = 6,
+	.tm_year = 114,
+	.tm_mon = 0,
+	.tm_mday = 1,
+	.tm_hour = 12,
+	.tm_min = 0,
+	.tm_sec = 0,
 };
 
 static int rk808_rtc_probe(struct platform_device *pdev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
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

