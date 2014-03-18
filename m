From: akpm@linux-foundation.org
Subject: + fs-freevxfs-vxfs_lookupc-update-function-comment.patch added to -mm tree
Date: Tue, 18 Mar 2014 14:27:44 -0700
Message-ID: <5328ba50.o8e5amS5ITcs0+sF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaCRV1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Mar 2014 17:27:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, fabf@skynet.be

Subject: + fs-freevxfs-vxfs_lookupc-update-function-comment.patch added to -mm tree
To: fabf@skynet.be,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Tue, 18 Mar 2014 14:27:44 -0700


The patch titled
     Subject: fs/freevxfs/vxfs_lookup.c: update function comment
has been added to the -mm tree.  Its filename is
     fs-freevxfs-vxfs_lookupc-update-function-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-freevxfs-vxfs_lookupc-update-function-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-freevxfs-vxfs_lookupc-update-function-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
fs-freevxfs-vxfs_lookupc-update-function-comment.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
befs-logging-clean-up.patch
befs-logging-clean-up-fix.patch
coda-add-__init-to-init_inodecache.patch
hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch
documentation-filesystems-ntfstxt-remove-changelog-reference.patch
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

