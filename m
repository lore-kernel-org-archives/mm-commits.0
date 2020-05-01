From: akpm@linux-foundation.org
Subject: +
 mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch added
 to -mm tree
Date: Fri, 01 May 2020 15:49:29 -0700
Message-ID: <20200501224929.ScPsuCOxj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAWta (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 May 2020 18:49:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix
has been added to the -mm tree.  Its filename is
     mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix

tweak capitalization in comments

Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/swap.h~mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix
+++ a/include/linux/swap.h
@@ -187,12 +187,12 @@ enum {
 #define SWAP_HAS_CACHE	0x40	/* Flag page is cached, in first swap_map */
 #define COUNT_CONTINUED	0x80	/* Flag swap_map continuation for full count */
 
-/* Special Value in first swap_map */
+/* Special value in first swap_map */
 #define SWAP_MAP_MAX	0x3e	/* Max count */
 #define SWAP_MAP_BAD	0x3f	/* Note page is bad */
 #define SWAP_MAP_SHMEM	0xbf	/* Owned by shmem/tmpfs */
 
-/* Special Value in each swap_map continuation */
+/* Special value in each swap_map continuation */
 #define SWAP_CONT_MAX	0x7f	/* Max count */
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
