From: akpm@linux-foundation.org
Subject: [merged] mm-truncate-functions-are-in-truncatec.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:19 -0700
Message-ID: <201107260752.p6Q7qMCG003121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab1GZHwx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: truncate functions are in truncate.c
has been removed from the -mm tree.  Its filename was
     mm-truncate-functions-are-in-truncatec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: truncate functions are in truncate.c
From: Hugh Dickins <hughd@google.com>

Correct comment on truncate_inode_pages*() in linux/mm.h; and remove
declaration of page_unuse(), it didn't exist even in 2.2.26 or 2.4.0!

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN include/linux/mm.h~mm-truncate-functions-are-in-truncatec include/linux/mm.h
--- a/include/linux/mm.h~mm-truncate-functions-are-in-truncatec
+++ a/include/linux/mm.h
@@ -1411,8 +1411,7 @@ extern int do_munmap(struct mm_struct *,
 
 extern unsigned long do_brk(unsigned long, unsigned long);
 
-/* filemap.c */
-extern unsigned long page_unuse(struct page *);
+/* truncate.c */
 extern void truncate_inode_pages(struct address_space *, loff_t);
 extern void truncate_inode_pages_range(struct address_space *,
 				       loff_t lstart, loff_t lend);
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
slub-partly-fix-freeze-in-__slab_free.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
panic-panic=-1-for-immediate-reboot.patch
panic-vt-do-not-force-oops-output-when-panic_timeout-0.patch
prio_tree-debugging-patch.patch

