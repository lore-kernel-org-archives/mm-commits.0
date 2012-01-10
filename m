From: akpm@linux-foundation.org
Subject: [folded] workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:57:14 -0800
Message-ID: <20120110225714.E48B65C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:34233 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2AJW5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:57:17 -0500
Received: by eaak10 with SMTP id k10so3666eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:57:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix
has been removed from the -mm tree.  Its filename was
     workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

This patch was dropped because it was folded into workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix

use __printf

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/workqueue.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/workqueue.h~workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix include/linux/workqueue.h
--- a/include/linux/workqueue.h~workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix
+++ a/include/linux/workqueue.h
@@ -298,8 +298,7 @@ extern struct workqueue_struct *system_f
 
 extern struct workqueue_struct *
 __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
-		      struct lock_class_key *key, const char *lock_name, ...)
-	__attribute__((format (printf, 1, 6)));
+	struct lock_class_key *key, const char *lock_name, ...) __printf(1, 6);
 
 /**
  * alloc_workqueue - allocate a workqueue
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
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name.patch

