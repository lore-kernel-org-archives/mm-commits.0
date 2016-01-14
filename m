From: akpm@linux-foundation.org
Subject: [folded-merged]
 account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch removed
 from -mm tree
Date: Thu, 14 Jan 2016 14:18:51 -0800
Message-ID: <56981ecb.OB3LXOdSZU1wS7Es%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbcANWSw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:18:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: account-certain-kmem-allocations-to-memcg-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch

This patch was dropped because it was folded into account-certain-kmem-allocations-to-memcg.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: account-certain-kmem-allocations-to-memcg-checkpatch-fixes

CHECK: spaces preferred around that '|' (ctx:VxV)
#130: FILE: drivers/staging/lustre/lustre/llite/super25.c:109:
+					    0, SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
 					                         ^

ERROR: code indent should use tabs where possible
#456: FILE: fs/gfs2/main.c:115:
+^I^I^I^I^I          SLAB_MEM_SPREAD|$

CHECK: spaces preferred around that '|' (ctx:VxV)
#1012: FILE: net/sunrpc/rpc_pipe.c:1503:
+						SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 						               ^

total: 1 errors, 0 warnings, 2 checks, 640 lines checked

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/account-certain-kmem-allocations-to-memcg.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/gfs2/main.c~account-certain-kmem-allocations-to-memcg-checkpatch-fixes fs/gfs2/main.c
--- a/fs/gfs2/main.c~account-certain-kmem-allocations-to-memcg-checkpatch-fixes
+++ a/fs/gfs2/main.c
@@ -114,7 +114,7 @@ static int __init init_gfs2_fs(void)
 	gfs2_inode_cachep = kmem_cache_create("gfs2_inode",
 					      sizeof(struct gfs2_inode),
 					      0,  SLAB_RECLAIM_ACCOUNT|
-					          SLAB_MEM_SPREAD|
+						  SLAB_MEM_SPREAD|
 						  SLAB_ACCOUNT,
 					      gfs2_init_inode_once);
 	if (!gfs2_inode_cachep)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
account-certain-kmem-allocations-to-memcg.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
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

