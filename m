From: akpm@linux-foundation.org
Subject: +
 mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch added to -mm tree
Date: Tue, 17 Nov 2015 16:05:04 -0800
Message-ID: <564bc0b0.2kRfcFFSjp5eNxp/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48786 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbbKRAFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 19:05:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch

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
Subject: mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes

WARNING: line over 80 characters
#56: FILE: include/linux/mmzone.h:578:
+	 * The NUMA zonelists are doubled because we need zonelists that restrict

total: 0 errors, 1 warnings, 39 lines checked

./patches/mm-zonelist-enumerate-zonelists-array-index.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/mmzone.h~mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes
+++ a/include/linux/mmzone.h
@@ -575,8 +575,8 @@ enum {
 	ZONELIST_FALLBACK,	/* zonelist with fallback */
 #ifdef CONFIG_NUMA
 	/*
-	 * The NUMA zonelists are doubled because we need zonelists that restrict
-	 * the allocations to a single node for __GFP_THISNODE.
+	 * The NUMA zonelists are doubled because we need zonelists that
+	 * restrict the allocations to a single node for __GFP_THISNODE.
 	 */
 	ZONELIST_NOFALLBACK,	/* zonelist without fallback (__GFP_THISNODE) */
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ncpfs-dont-allow-negative-timeouts-fix.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

