From: akpm@linux-foundation.org
Subject: [merged] fs-efs-superc-add-__init-to-init_inodecache.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:34:34 -0700
Message-ID: <533f094a.oJ/MXwY+8dIQRI8L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbaDDTee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] fs-efs-superc-add-__init-to-init_inodecache.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:34:34 -0700


The patch titled
     Subject: fs/efs/super.c: add __init to init_inodecache()
has been removed from the -mm tree.  Its filename was
     fs-efs-superc-add-__init-to-init_inodecache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/efs/super.c: add __init to init_inodecache()

init_inodecache is only called by __init init_efs_fs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/efs/super.c~fs-efs-superc-add-__init-to-init_inodecache fs/efs/super.c
--- a/fs/efs/super.c~fs-efs-superc-add-__init-to-init_inodecache
+++ a/fs/efs/super.c
@@ -91,7 +91,7 @@ static void init_once(void *foo)
 	inode_init_once(&ei->vfs_inode);
 }
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	efs_inode_cachep = kmem_cache_create("efs_inode_cache",
 				sizeof(struct efs_inode_info),
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ntfs-logging-clean-up.patch
mm-memblockc-use-pfn_phys.patch
mm-readaheadc-inline-ra_submit.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
affs-mount-option-to-avoid-filename-truncates.patch
fs-bfs-inodec-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

