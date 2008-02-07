From: akpm@linux-foundation.org
Subject: - ncpfs-update-diagnostic-strings-to-match-routine-names.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:01 -0800
Message-ID: <200802070022.m170MgpG006457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52188 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935054AbYBGAoi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, VANDROVE@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     NCPFS: update diagnostic strings to match routine names.
has been removed from the -mm tree.  Its filename was
     ncpfs-update-diagnostic-strings-to-match-routine-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: NCPFS: update diagnostic strings to match routine names.
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ncpfs/inode.c~ncpfs-update-diagnostic-strings-to-match-routine-names fs/ncpfs/inode.c
--- a/fs/ncpfs/inode.c~ncpfs-update-diagnostic-strings-to-match-routine-names
+++ a/fs/ncpfs/inode.c
@@ -987,7 +987,7 @@ static struct file_system_type ncp_fs_ty
 static int __init init_ncp_fs(void)
 {
 	int err;
-	DPRINTK("ncpfs: init_module called\n");
+	DPRINTK("ncpfs: init_ncp_fs called\n");
 
 	err = init_inodecache();
 	if (err)
@@ -1004,7 +1004,7 @@ out1:
 
 static void __exit exit_ncp_fs(void)
 {
-	DPRINTK("ncpfs: cleanup_module called\n");
+	DPRINTK("ncpfs: exit_ncp_fs called\n");
 	unregister_filesystem(&ncp_fs_type);
 	destroy_inodecache();
 }
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-hwmon.patch
git-xfs.patch
