From: akpm@linux-foundation.org
Subject: [folded] drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:49:52 -0800
Message-ID: <20120110224952.C1E6010006E@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:59642 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab2AJWtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:49:53 -0500
Received: by yhpp56 with SMTP id p56so13906yhp.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:49:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jekhor@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch

This patch was dropped because it was folded into drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix

use conventional comment layout

Cc: Yauhen Kharuzhy <jekhor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix
+++ a/drivers/rtc/rtc-mxc.c
@@ -290,8 +290,8 @@ static int mxc_rtc_read_time(struct devi
  */
 static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
 {
-	/* RTC_DAYR register is 9-bit in MX1 SoC,
-	 * save time and day of year only
+	/*
+	 * TTC_DAYR register is 9-bit in MX1 SoC, save time and day of year only
 	 */
 	if (cpu_is_mx1()) {
 		struct rtc_time tm;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma.patch
mempool-fix-first-round-failure-behavior.patch
backlight-convert-pwm_bl-to-dev_pm_ops.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

