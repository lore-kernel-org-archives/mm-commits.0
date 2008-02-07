From: akpm@linux-foundation.org
Subject: - hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:06 -0800
Message-ID: <200802070022.m170Ml48006468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935064AbYBGAon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     hfs: update comment to reflect actual init and exit routines
has been removed from the -mm tree.  Its filename was
     hfs-update-comment-to-reflect-actual-init-and-exit-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-hwmon.patch
git-xfs.patch
