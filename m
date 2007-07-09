From: akpm@linux-foundation.org
Subject: - minix-convert-to-new-aops-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 13:56:27 -0700
Message-ID: <200707092056.l69KuRJH011099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45695 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960AbXGIU4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 16:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     minix: convert to new aops fix
has been removed from the -mm tree.  Its filename was
     minix-convert-to-new-aops-fix.patch

This patch was dropped because it was folded into minix-convert-to-new-aops.patch

------------------------------------------------------
Subject: minix: convert to new aops fix
From: Nick Piggin <npiggin@suse.de>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/minix.h |    3 +++
 1 files changed, 3 insertions(+)

diff -puN fs/minix/minix.h~minix-convert-to-new-aops-fix fs/minix/minix.h
--- a/fs/minix/minix.h~minix-convert-to-new-aops-fix
+++ a/fs/minix/minix.h
@@ -54,6 +54,9 @@ extern int minix_new_block(struct inode 
 extern void minix_free_block(struct inode *inode, unsigned long block);
 extern unsigned long minix_count_free_blocks(struct minix_sb_info *sbi);
 extern int minix_getattr(struct vfsmount *, struct dentry *, struct kstat *);
+extern int __minix_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata);
 
 extern void V1_minix_truncate(struct inode *);
 extern void V2_minix_truncate(struct inode *);
_

Patches currently in -mm which might be from npiggin@suse.de are

slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
ocfs2-convert-to-new-aops.patch
fix-read-truncate-race.patch
fs-remove-some-aop_truncated_page.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
