From: akpm@osdl.org
Subject: - fs-reiserfs-add-missing-brackets.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:16:09 -0800
Message-ID: <200612072316.kB7NG9DB030789@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53601 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163808AbWLGXQN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     fs: reiserfs add missing brackets
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-add-missing-brackets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: reiserfs add missing brackets
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/reiserfs_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/reiserfs_fs.h~fs-reiserfs-add-missing-brackets include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~fs-reiserfs-add-missing-brackets
+++ a/include/linux/reiserfs_fs.h
@@ -739,7 +739,7 @@ struct block_head {
 #define PUT_B_FREE_SPACE(p_s_bh,val)  do { set_blkh_free_space(B_BLK_HEAD(p_s_bh),val); } while (0)
 
 /* Get right delimiting key. -- little endian */
-#define B_PRIGHT_DELIM_KEY(p_s_bh)   (&(blk_right_delim_key(B_BLK_HEAD(p_s_bh))
+#define B_PRIGHT_DELIM_KEY(p_s_bh)   (&(blk_right_delim_key(B_BLK_HEAD(p_s_bh))))
 
 /* Does the buffer contain a disk leaf. */
 #define B_IS_ITEMS_LEVEL(p_s_bh)     (B_LEVEL(p_s_bh) == DISK_LEAF_NODE_LEVEL)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch
sparc64-dma-remove-extra-brackets.patch
video-cyberfb-broken-macro-removal.patch
video-neofb-stray-bracket-fix.patch
video-pm3fb-macros-fix.patch

