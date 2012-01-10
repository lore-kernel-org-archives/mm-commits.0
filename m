From: akpm@linux-foundation.org
Subject: [folded] drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:53:28 -0800
Message-ID: <20120110225329.40635100071@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:32887 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2AJWxa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:53:30 -0500
Received: by yenm5 with SMTP id m5so14339yen.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:53:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, daniel@caiaq.de, jekhor@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-rtc-rtc-mxcc-make-alarm-work-fix
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch

This patch was dropped because it was folded into drivers-rtc-rtc-mxcc-make-alarm-work.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-rtc-rtc-mxcc-make-alarm-work-fix

fix CONFIG_PM=n build

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Yauhen Kharuzhy <jekhor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-make-alarm-work-fix drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~drivers-rtc-rtc-mxcc-make-alarm-work-fix
+++ a/drivers/rtc/rtc-mxc.c
@@ -466,12 +466,12 @@ static int mxc_rtc_resume(struct device 
 
 	return 0;
 }
-#endif
 
 static struct dev_pm_ops mxc_rtc_pm_ops = {
 	.suspend	= mxc_rtc_suspend,
 	.resume		= mxc_rtc_resume,
 };
+#endif
 
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
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
drivers-rtc-rtc-mxcc-make-alarm-work.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

