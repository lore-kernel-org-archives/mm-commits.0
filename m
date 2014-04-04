From: akpm@linux-foundation.org
Subject: [merged] fs-freevxfs-vxfs_lookupc-update-function-comment.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:34 -0700
Message-ID: <533f081e.RDUTelGkZv0kAsay%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaDDT3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, fabf@skynet.be

Subject: [merged] fs-freevxfs-vxfs_lookupc-update-function-comment.patch removed from -mm tree
To: fabf@skynet.be,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:34 -0700


The patch titled
     Subject: fs/freevxfs/vxfs_lookup.c: update function comment
has been removed from the -mm tree.  Its filename was
     fs-freevxfs-vxfs_lookupc-update-function-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/freevxfs/vxfs_lookup.c: update function comment

nameidata was replaced by flags in 00cd8dd3bf95f2 ("stop passing nameidata
to ->lookup()").

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_lookup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/freevxfs/vxfs_lookup.c~fs-freevxfs-vxfs_lookupc-update-function-comment fs/freevxfs/vxfs_lookup.c
--- a/fs/freevxfs/vxfs_lookup.c~fs-freevxfs-vxfs_lookupc-update-function-comment
+++ a/fs/freevxfs/vxfs_lookup.c
@@ -192,7 +192,7 @@ vxfs_inode_by_name(struct inode *dip, st
  * vxfs_lookup - lookup pathname component
  * @dip:	dir in which we lookup
  * @dp:		dentry we lookup
- * @nd:		lookup nameidata
+ * @flags:	lookup flags
  *
  * Description:
  *   vxfs_lookup tries to lookup the pathname component described
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

