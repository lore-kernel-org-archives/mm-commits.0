From: akpm@linux-foundation.org
Subject: +
 rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch added to -mm tree
Date: Mon, 05 Oct 2015 14:07:16 -0700
Message-ID: <5612e684.JeDt+wMHRy6qGbVH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbbJEVHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Oct 2015 17:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dev@codyps.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix
has been added to the -mm tree.  Its filename is
     rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch

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
Subject: rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix

s/this function/rbtree_postorder_for_each_entry_safe()/ (it isn't a function!)

Cc: Cody P Schafer <dev@codyps.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/rbtree.h~rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix
+++ a/include/linux/rbtree.h
@@ -109,9 +109,9 @@ static inline void rb_link_node_rcu(stru
  * @root:	'rb_root *' of the rbtree.
  * @field:	the name of the rb_node field within 'type'.
  *
- * This function provides a similar guarantee as list_for_each_entry_safe() and
- * allows the iteration to continue independent of changes to @pos by the body
- * of the loop.
+ * rbtree_postorder_for_each_entry_safe() provides a similar guarantee as
+ * list_for_each_entry_safe() and allows the iteration to continue independent
+ * of changes to @pos by the body of the loop.
  *
  * Note, however, that it cannot handle other modifications that re-order the
  * rbtree it is iterating over. This includes calling rb_erase() on @pos, as
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
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
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
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
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

