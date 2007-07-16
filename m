From: akpm@linux-foundation.org
Subject: - remove-odd-and-misleading-comments-from-uioh.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:26 -0700
Message-ID: <200707162055.l6GKtQbh001913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759029AbXGPVP0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     remove odd and misleading comments from uio.h
has been removed from the -mm tree.  Its filename was
     remove-odd-and-misleading-comments-from-uioh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove odd and misleading comments from uio.h
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uio.h |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN include/linux/uio.h~remove-odd-and-misleading-comments-from-uioh include/linux/uio.h
--- a/include/linux/uio.h~remove-odd-and-misleading-comments-from-uioh
+++ a/include/linux/uio.h
@@ -13,10 +13,6 @@
  *		2 of the License, or (at your option) any later version.
  */
 
-
-/* A word of warning: Our uio structure will clash with the C library one (which is now obsolete). Remove the C
-   library one from sys/uio.h if you have a very old library set */
-
 struct iovec
 {
 	void __user *iov_base;	/* BSD uses caddr_t (1003.1g requires void *) */
@@ -38,11 +34,6 @@ struct kvec {
  
 #define UIO_FASTIOV	8
 #define UIO_MAXIOV	1024
-#if 0
-#define UIO_MAXIOV	16	/* Maximum iovec's in one operation 
-				   16 matches BSD */
-                                /* Beg pardon: BSD has 1024 --ANK */
-#endif
 
 /*
  * Total number of bytes covered by an iovec.
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-powerpc.patch
git-dvb.patch
git-ubi.patch
git-ocfs2.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
git-xfs.patch
sysv-convert-to-new-aops.patch
ptrace_peekdata-consolidation.patch
ptrace_pokedata-consolidation.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
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
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
