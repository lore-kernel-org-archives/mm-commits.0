From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Tue, 06 Feb 2018 11:46:17 -0800
Message-ID: <20180206194617.8Ck-krV12%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752873AbeBFTqT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 14:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/overlayfs/export.c |    6 ------
 fs/overlayfs/namei.c  |    5 -----
 2 files changed, 11 deletions(-)

diff -puN fs/overlayfs/export.c~linux-next-git-rejects fs/overlayfs/export.c
--- a/fs/overlayfs/export.c~linux-next-git-rejects
+++ a/fs/overlayfs/export.c
@@ -108,12 +108,6 @@ static int ovl_d_to_fh(struct dentry *de
 
 	/* Encode an upper or origin file handle */
 	fh = ovl_encode_fh(origin ?: ovl_dentry_upper(dentry), !origin);
-<<<<<<< HEAD
-	err = PTR_ERR(fh);
-	if (IS_ERR(fh))
-		goto fail;
-=======
->>>>>>> linux-next/akpm-base
 
 	err = -EOVERFLOW;
 	if (fh->len > buflen)
diff -puN fs/overlayfs/namei.c~linux-next-git-rejects fs/overlayfs/namei.c
--- a/fs/overlayfs/namei.c~linux-next-git-rejects
+++ a/fs/overlayfs/namei.c
@@ -976,11 +976,6 @@ struct dentry *ovl_lookup(struct inode *
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
-<<<<<<< HEAD
-		if (ctr)
-			origin = stack[0].dentry;
-=======
->>>>>>> linux-next/akpm-base
 		inode = ovl_get_inode(dentry->d_sb, upperdentry, origin, index,
 				      ctr);
 		err = PTR_ERR(inode);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
include-linux-sched-mmh-re-inline-mmdrop.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-fix.patch
kasan-clean-up-kasan_shadow_scale_shift-usage-checkpatch-fixes.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
maintainers-update-arm-oxnas-platform-support-patterns-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

