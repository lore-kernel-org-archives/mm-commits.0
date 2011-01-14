From: akpm@linux-foundation.org
Subject: [merged] sync_inode_metadata-fix-comment.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:44:35 -0800
Message-ID: <201101142247.p0EMlP63004991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:47:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     sync_inode_metadata: fix comment
has been removed from the -mm tree.  Its filename was
     sync_inode_metadata-fix-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sync_inode_metadata: fix comment
From: Andrew Morton <akpm@linux-foundation.org>

Use correct function name, remove incorrect apostrophe

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~sync_inode_metadata-fix-comment fs/fs-writeback.c
--- a/fs/fs-writeback.c~sync_inode_metadata-fix-comment
+++ a/fs/fs-writeback.c
@@ -1303,11 +1303,11 @@ int sync_inode(struct inode *inode, stru
 EXPORT_SYMBOL(sync_inode);
 
 /**
- * sync_inode - write an inode to disk
+ * sync_inode_metadata - write an inode to disk
  * @inode: the inode to sync
  * @wait: wait for I/O to complete.
  *
- * Write an inode to disk and adjust it's dirty state after completion.
+ * Write an inode to disk and adjust its dirty state after completion.
  *
  * Note: only writes the actual inode, no associated data or other metadata.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-nfc-pn544c-fix-min_t-warnings.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

