From: akpm@linux-foundation.org
Subject: - dcache-trivial-comment-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:00:05 -0700
Message-ID: <200710180700.l9I705wH031072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763736AbXJRHQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, mm-commits@vger.kernel.org


The patch titled
     dcache: trivial comment fix
has been removed from the -mm tree.  Its filename was
     dcache-trivial-comment-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dcache: trivial comment fix
From: "J. Bruce Fields" <bfields@fieldses.org>

As it stands this comment is confusing, and not quite grammatical.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/dcache.c~dcache-trivial-comment-fix fs/dcache.c
--- a/fs/dcache.c~dcache-trivial-comment-fix
+++ a/fs/dcache.c
@@ -1510,8 +1510,8 @@ static void switch_names(struct dentry *
  * This forceful removal will result in ugly /proc output if
  * somebody holds a file open that got deleted due to a rename.
  * We could be nicer about the deleted file, and let it show
- * up under the name it got deleted rather than the name that
- * deleted it.
+ * up under the name it had before it was deleted rather than
+ * the original name of the file that was moved on top of it.
  */
  
 /*
_

Patches currently in -mm which might be from bfields@fieldses.org are

origin.patch
git-nfs-make-nfs_wb_page_priority-static.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
