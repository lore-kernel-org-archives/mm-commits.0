From: akpm@linux-foundation.org
Subject: [folded] nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:32:43 -0700
Message-ID: <200904062232.n36MWhDb017018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756553AbZDFWfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:35:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch

This patch was dropped because it was folded into nilfs2-integrated-block-mapping.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#49: FILE: fs/nilfs2/bmap.c:737:
+^I^I^I   ^I  NILFS_BMAP_SMALL_LOW,$

total: 1 errors, 0 warnings, 45 lines checked

./patches/nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/bmap.c~nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes fs/nilfs2/bmap.c
--- a/fs/nilfs2/bmap.c~nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes
+++ a/fs/nilfs2/bmap.c
@@ -734,7 +734,7 @@ int nilfs_bmap_read(struct nilfs_bmap *b
 				 NILFS_BMAP_LARGE_LOW,
 				 NILFS_BMAP_LARGE_HIGH) :
 		nilfs_direct_init(bmap,
-			   	  NILFS_BMAP_SMALL_LOW,
+				  NILFS_BMAP_SMALL_LOW,
 				  NILFS_BMAP_SMALL_HIGH);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-add-proc-controls-for-pdflush-threads.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
nilfs2-integrated-block-mapping.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

