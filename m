From: akpm@linux-foundation.org
Subject: + mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch added to
 -mm tree
Date: Sat, 07 Nov 2015 00:50:29 -0800
Message-ID: <563dbb55.46vauIWbYIWC7fDA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbKGIua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 7 Nov 2015 03:50:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-adjust-for-new-thp-refcounting-fix
has been added to the -mm tree.  Its filename is
     mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch

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
Subject: mm-hwpoison-adjust-for-new-thp-refcounting-fix

remove unneeeeded #define, per Kirill

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/mm.h~mm-hwpoison-adjust-for-new-thp-refcounting-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-hwpoison-adjust-for-new-thp-refcounting-fix
+++ a/include/linux/mm.h
@@ -2194,7 +2194,6 @@ extern void memory_failure_queue(unsigne
 extern int unpoison_memory(unsigned long pfn);
 extern int get_hwpoison_page(struct page *page);
 #define put_hwpoison_page(page)	put_page(page)
-extern void put_hwpoison_page(struct page *page);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-reflow-comment.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

