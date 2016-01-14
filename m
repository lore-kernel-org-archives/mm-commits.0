From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch removed
 from -mm tree
Date: Thu, 14 Jan 2016 14:21:22 -0800
Message-ID: <56981f62.m67yv6MvmxnuCZQm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbcANWVX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:21:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, baiyaowei@cmss.chinamobile.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-zonelist-enumerate-zonelists-array-index.patch

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

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm-zonelist-enumerate-zonelists-array-index.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
mm-vmalloc-remove-vm_vpages-fix.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

