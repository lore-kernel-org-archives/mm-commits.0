From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch removed
 from -mm tree
Date: Thu, 14 Jan 2016 14:22:55 -0800
Message-ID: <56981fbf.6R8ZOuzBR/c+J0bL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44326 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbcANWW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:22:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-get-rid-of-__alloc_pages_high_priority.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes

WARNING: line over 80 characters
#66: FILE: mm/page_alloc.c:3025:
+							ALLOC_NO_WATERMARKS, ac);

total: 0 errors, 1 warnings, 50 lines checked

./patches/mm-get-rid-of-__alloc_pages_high_priority.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -3022,7 +3022,7 @@ retry:
 		ac->zonelist = node_zonelist(numa_node_id(), gfp_mask);
 		do {
 			page = get_page_from_freelist(gfp_mask, order,
-							ALLOC_NO_WATERMARKS, ac);
+						      ALLOC_NO_WATERMARKS, ac);
 			if (page)
 				goto got_pg;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm-get-rid-of-__alloc_pages_high_priority.patch
mm-vmalloc-remove-vm_vpages-fix.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

