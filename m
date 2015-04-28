From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 28 Apr 2015 12:31:38 -0700
Message-ID: <553fe01a.5X68jQMyzpEkO8JX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030711AbbD1Tbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Apr 2015 15:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/symlink.c              |    5 -----
 net/sunrpc/xprtrdma/fmr_ops.c  |    4 ----
 net/sunrpc/xprtrdma/frwr_ops.c |    4 ----
 3 files changed, 13 deletions(-)

diff -puN fs/btrfs/xattr.c~linux-next-git-rejects fs/btrfs/xattr.c
diff -puN fs/xfs/xfs_iops.c~linux-next-git-rejects fs/xfs/xfs_iops.c
diff -puN fs/ext4/symlink.c~linux-next-git-rejects fs/ext4/symlink.c
--- a/fs/ext4/symlink.c~linux-next-git-rejects
+++ a/fs/ext4/symlink.c
@@ -43,13 +43,8 @@ static void *ext4_follow_link(struct den
 		return ctx;
 
 	if (ext4_inode_is_fast_symlink(inode)) {
-<<<<<<< HEAD
-		caddr = (char *) EXT4_I(inode)->i_data;
-		max_size = sizeof(EXT4_I(inode)->i_data);
-=======
 		caddr = (char *) EXT4_I(d_inode(dentry))->i_data;
 		max_size = sizeof(EXT4_I(d_inode(dentry))->i_data);
->>>>>>> linux-next/akpm-base
 	} else {
 		cpage = read_mapping_page(inode->i_mapping, 0, NULL);
 		if (IS_ERR(cpage)) {
diff -puN net/sunrpc/xprtrdma/fmr_ops.c~linux-next-git-rejects net/sunrpc/xprtrdma/fmr_ops.c
--- a/net/sunrpc/xprtrdma/fmr_ops.c~linux-next-git-rejects
+++ a/net/sunrpc/xprtrdma/fmr_ops.c
@@ -54,11 +54,7 @@ fmr_op_init(struct rpcrdma_xprt *r_xprt)
 	INIT_LIST_HEAD(&buf->rb_all);
 
 	i = (buf->rb_max_requests + 1) * RPCRDMA_MAX_SEGS;
-<<<<<<< HEAD
-	dprintk("RPC:       %s: initializing %d FMRs\n", __func__, i);
-=======
 	dprintk("RPC:       %s: initalizing %d FMRs\n", __func__, i);
->>>>>>> linux-next/akpm-base
 
 	while (i--) {
 		r = kzalloc(sizeof(*r), GFP_KERNEL);
diff -puN net/sunrpc/xprtrdma/frwr_ops.c~linux-next-git-rejects net/sunrpc/xprtrdma/frwr_ops.c
--- a/net/sunrpc/xprtrdma/frwr_ops.c~linux-next-git-rejects
+++ a/net/sunrpc/xprtrdma/frwr_ops.c
@@ -146,11 +146,7 @@ frwr_op_init(struct rpcrdma_xprt *r_xprt
 	INIT_LIST_HEAD(&buf->rb_all);
 
 	i = (buf->rb_max_requests + 1) * RPCRDMA_MAX_SEGS;
-<<<<<<< HEAD
-	dprintk("RPC:       %s: initializing %d FRMRs\n", __func__, i);
-=======
 	dprintk("RPC:       %s: initalizing %d FRMRs\n", __func__, i);
->>>>>>> linux-next/akpm-base
 
 	while (i--) {
 		struct rpcrdma_mw *r;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
maintainers-add-co-maintainer-for-led-subsystem.patch
revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-checkpatch-fixes.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

