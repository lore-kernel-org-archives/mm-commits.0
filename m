From: akpm@linux-foundation.org
Subject: + mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch added to -mm tree
Date: Thu, 16 Aug 2012 11:14:18 -0700
Message-ID: <20120816181419.20E2D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48068 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2HPSOV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:14:21 -0400
Received: by weyr1 with SMTP id r1so147455wey.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:14:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, hannes@cmpxchg.org, kosaki.motohiro@gmail.com, minchan@kernel.org, sanbai@taobao.com


The patch titled
     Subject: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix
has been added to the -mm tree.  Its filename is
     mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix

tweak comment

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Robin Dong <sanbai@taobao.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix mm/swap.c
--- a/mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix
+++ a/mm/swap.c
@@ -447,9 +447,8 @@ void mark_page_accessed(struct page *pag
 EXPORT_SYMBOL(mark_page_accessed);
 
 /*
- * Check pagevec space before adding new page into as
- * it will prevent ununiform page status in
- * mark_page_accessed() after __lru_cache_add()
+ * Check the pagevec space before adding a new page into it, to prevent
+ * nonuniform page status in mark_page_accessed() after __lru_cache_add().
  */
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-restructure-kmem_cache_create-to-move-debug-cache-integrity-checks-into-a-new-function.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

