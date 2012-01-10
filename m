From: akpm@linux-foundation.org
Subject: [folded] mm-simplify-find_vma_prev-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 14:46:00 -0800
Message-ID: <20120110224600.C34E11E02F2@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56576 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AJWqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 17:46:02 -0500
Received: by yenm5 with SMTP id m5so13082yen.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 14:46:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-find_vma_prev-fix
has been removed from the -mm tree.  Its filename was
     mm-simplify-find_vma_prev-fix.patch

This patch was dropped because it was folded into mm-simplify-find_vma_prev.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-simplify-find_vma_prev-fix

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-simplify-find_vma_prev-fix mm/mmap.c
--- a/mm/mmap.c~mm-simplify-find_vma_prev-fix
+++ a/mm/mmap.c
@@ -1628,7 +1628,7 @@ EXPORT_SYMBOL(find_vma);
 
 /*
  * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
- * Note: pprev is set to NULL when return value is NULL.
+ * Note: *pprev is set to NULL when the return value is NULL.
  */
 struct vm_area_struct *
 find_vma_prev(struct mm_struct *mm, unsigned long addr, struct vm_area_struct **pprev)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-hugetlbc-fix-virtual-address-handling-in-hugetlb-fault.patch
mm-more-intensive-memory-corruption-debug.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-simplify-find_vma_prev.patch
mm-hugetlb-fix-pgoff-computation-when-unmapping-page-from-vma-fix.patch
mempool-fix-first-round-failure-behavior-fix.patch
backlight-convert-pwm_bl-to-dev_pm_ops-fix.patch
leds-add-driver-for-tca6507-led-controller.patch
checkpatch-improve-memset-and-min-max-with-cast-checking-fix.patch
checkpatch-catch-all-occurances-of-type-and-cast-spacing-errors-per-line-checkpatch-fixes.patch
drivers-rtc-rtc-mxcc-fix-setting-time-for-mx1-soc-fix.patch
drivers-rtc-rtc-mxcc-make-alarm-work-fix.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-checkpatch-fixes.patch
rtc-ab8500-add-calibration-attribute-to-ab8500-rtc-v3-checkpatch-fixes.patch
procfs-introduce-the-proc-pid-map_files-directory-checkpatch-fixes.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options-fix-2.patch
workqueue-make-alloc_workqueue-take-printf-fmt-and-args-for-name-fix.patch

