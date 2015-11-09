From: akpm@linux-foundation.org
Subject: [merged] include-linux-mmzoneh-reflow-comment.patch removed from
 -mm tree
Date: Mon, 09 Nov 2015 11:44:40 -0800
Message-ID: <5640f7a8.zDfpkLKkQQ9YDaSi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbbKITok (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: reflow comment
has been removed from the -mm tree.  Its filename was
     include-linux-mmzoneh-reflow-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

