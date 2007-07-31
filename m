From: akpm@linux-foundation.org
Subject: - ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:05 -0700
Message-ID: <200707312358.l6VNw5UE029524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60778 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759407AbXHAAQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, petr@vandrovec.name, mm-commits@vger.kernel.org


The patch titled
     NCP: delete test of long-deceased CONFIG_NCPFS_DEBUGDENTRY
has been removed from the -mm tree.  Its filename was
     ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NCP: delete test of long-deceased CONFIG_NCPFS_DEBUGDENTRY
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ncplib_kernel.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/ncpfs/ncplib_kernel.c~ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry fs/ncpfs/ncplib_kernel.c
--- a/fs/ncpfs/ncplib_kernel.c~ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry
+++ a/fs/ncpfs/ncplib_kernel.c
@@ -726,9 +726,6 @@ ncp_del_file_or_subdir2(struct ncp_serve
 	__le32 dirent;
 
 	if (!inode) {
-#ifdef CONFIG_NCPFS_DEBUGDENTRY
-		PRINTK("ncpfs: ncpdel2: dentry->d_inode == NULL\n");
-#endif
 		return 0xFF;	/* Any error */
 	}
 	volnum = NCP_FINFO(inode)->volNumber;
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-kvm.patch
git-mtd.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
m68knommu-remove-unused-config-symbol-config_disktel.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
kconfig-make-instrumentation-support-non-experimental.patch
