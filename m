From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 14:38:20 -0700
Message-ID: <55ef554c.A57TQzpURfwPPkbR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52630 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbbIHViV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:38:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-improve-__gfp_noretry-comment-based-on-implementation-fix
has been removed from the -mm tree.  Its filename was
     mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch

This patch was dropped because it was folded into mm-improve-__gfp_noretry-comment-based-on-implementation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-improve-__gfp_noretry-comment-based-on-implementation-fix

s/has/have/

Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-improve-__gfp_noretry-comment-based-on-implementation-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-improve-__gfp_noretry-comment-based-on-implementation-fix
+++ a/include/linux/gfp.h
@@ -64,8 +64,8 @@ struct vm_area_struct;
  * loop around allocator.
  *
  * __GFP_NORETRY: The VM implementation must not retry indefinitely and will
- * return NULL when direct reclaim and memory compaction has failed to allow the
- * allocation to succeed.  The OOM killer is not called with the current
+ * return NULL when direct reclaim and memory compaction have failed to allow
+ * the allocation to succeed.  The OOM killer is not called with the current
  * implementation.
  *
  * __GFP_MOVABLE: Flag that this page will be movable by the page migration
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

dax-revert-userfaultfd-change.patch
mm-improve-__gfp_noretry-comment-based-on-implementation.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch

