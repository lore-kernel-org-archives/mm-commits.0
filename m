From: akpm@linux-foundation.org
Subject: + hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:34:57 -0800
Message-ID: <200711262334.lAQNYvMC028891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38306 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755484AbXKZXfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:35:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, zippel@linux-m68k.org


The patch titled
     hfs: update comment to reflect actual init and exit routines
has been added to the -mm tree.  Its filename is
     hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hfs: update comment to reflect actual init and exit routines
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/hfs/super.c~hfs-update-comment-to-reflect-actual-init-and-exit-routines fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-update-comment-to-reflect-actual-init-and-exit-routines
+++ a/fs/hfs/super.c
@@ -6,7 +6,7 @@
  * This file may be distributed under the terms of the GNU General Public License.
  *
  * This file contains hfs_read_super(), some of the super_ops and
- * init_module() and cleanup_module().	The remaining super_ops are in
+ * init_hfs_fs() and exit_hfs_fs().  The remaining super_ops are in
  * inode.c since they deal with inodes.
  *
  * Based on the minix file system code, (C) 1991, 1992 by Linus Torvalds
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

git-arm.patch
git-hwmon.patch
git-mips.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
blackfin-typo-config_rtc_bfin_module.patch
git-nfsd.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
m68knommu-remove-vestiges-of-non-existent-disktel.patch
uml-delete-some-unused-headers.patch
rd-use-is_power_of_2-in-drivers-block-rdc.patch
log2h-define-order_base_2-macro-for-convenience.patch
a-few-corrections-to-include-linux-kbuild.patch
ncpfs-update-diagnostic-strings-to-match-routine-names.patch
hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
irda-clean-up-superfluous-and-self-evident-comments.patch
