From: akpm@linux-foundation.org
Subject: - nameic-remove-utterly-outdated-comment.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:08 -0700
Message-ID: <200705090246.l492k81b008816@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031797AbXEICqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     namei.c: remove utterly outdated comment
has been removed from the -mm tree.  Its filename was
     nameic-remove-utterly-outdated-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: namei.c: remove utterly outdated comment
From: Christoph Hellwig <hch@lst.de>

We don't have a routine called namei() anymore since at least 2.3.x, and
the comment is just totally out of sync with the current lookup logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN fs/namei.c~nameic-remove-utterly-outdated-comment fs/namei.c
--- a/fs/namei.c~nameic-remove-utterly-outdated-comment
+++ a/fs/namei.c
@@ -1350,17 +1350,6 @@ struct dentry *lookup_one_len_kern(const
 	return __lookup_hash_kern(&this, base, NULL);
 }
 
-/*
- *	namei()
- *
- * is used by most simple commands to get the inode of a specified name.
- * Open, link etc use their own routines, but this is enough for things
- * like 'chmod' etc.
- *
- * namei exists in two versions: namei/lnamei. The only difference is
- * that namei follows links, while lnamei does not.
- * SMP-safe
- */
 int fastcall __user_walk_fd(int dfd, const char __user *name, unsigned flags,
 			    struct nameidata *nd)
 {
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
git-scsi-misc.patch
knfsd-trivial-makefile-cleanup.patch
aio-is-unlikely.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
