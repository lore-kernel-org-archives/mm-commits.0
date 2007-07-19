From: akpm@linux-foundation.org
Subject: + ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry.patch added to -mm tree
Date: Thu, 19 Jul 2007 15:21:12 -0700
Message-ID: <200707192221.l6JMLCtd025933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760133AbXGSWVf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 18:21:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, petr@vandrovec.name


The patch titled
     NCP: delete test of long-deceased CONFIG_NCPFS_DEBUGDENTRY
has been added to the -mm tree.  Its filename is
     ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NCP: delete test of long-deceased CONFIG_NCPFS_DEBUGDENTRY
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ncplib_kernel.c |    3 ---
 1 files changed, 3 deletions(-)

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
git-alsa.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry.patch
