From: akpm@linux-foundation.org
Subject: [merged] fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:32 -0700
Message-ID: <533f081c.Ax1/HyM+8c+nEaTG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaDDT3c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:32 -0700


The patch titled
     Subject: fs/cifs/cifsfs.c: add __init to cifs_init_inodecache()
has been removed from the -mm tree.  Its filename was
     fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/cifs/cifsfs.c: add __init to cifs_init_inodecache()

cifs_init_inodecache is only called by __init init_cifs.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cifs/cifsfs.c~fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache
+++ a/fs/cifs/cifsfs.c
@@ -1005,7 +1005,7 @@ cifs_init_once(void *inode)
 	init_rwsem(&cifsi->lock_sem);
 }
 
-static int
+static int __init
 cifs_init_inodecache(void)
 {
 	cifs_inode_cachep = kmem_cache_create("cifs_inode_cache",
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

