From: akpm@linux-foundation.org
Subject: + include-linux-mmzoneh-reflow-comment.patch added to -mm tree
Date: Thu, 01 Oct 2015 16:26:18 -0700
Message-ID: <560dc11a.Mn7lc20DEU+Simb+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbJAX0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 19:26:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: reflow comment
has been added to the -mm tree.  Its filename is
     include-linux-mmzoneh-reflow-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-mmzoneh-reflow-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-mmzoneh-reflow-comment.patch

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
Subject: include/linux/mmzone.h: reflow comment

Someone has an 86 column display.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~include-linux-mmzoneh-reflow-comment include/linux/mmzone.h
--- a/include/linux/mmzone.h~include-linux-mmzoneh-reflow-comment
+++ a/include/linux/mmzone.h
@@ -337,12 +337,13 @@ struct zone {
 	unsigned long nr_reserved_highatomic;
 
 	/*
-	 * We don't know if the memory that we're going to allocate will be freeable
-	 * or/and it will be released eventually, so to avoid totally wasting several
-	 * GB of ram we must reserve some of the lower zone memory (otherwise we risk
-	 * to run OOM on the lower zones despite there's tons of freeable ram
-	 * on the higher zones). This array is recalculated at runtime if the
-	 * sysctl_lowmem_reserve_ratio sysctl changes.
+	 * We don't know if the memory that we're going to allocate will be
+	 * freeable or/and it will be released eventually, so to avoid totally
+	 * wasting several GB of ram we must reserve some of the lower zone
+	 * memory (otherwise we risk to run OOM on the lower zones despite
+	 * there being tons of freeable ram on the higher zones).  This array is
+	 * recalculated at runtime if the sysctl_lowmem_reserve_ratio sysctl
+	 * changes.
 	 */
 	long lowmem_reserve[MAX_NR_ZONES];
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
linux-next-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

