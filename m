From: akpm@linux-foundation.org
Subject: + remove-odd-and-misleading-comments-from-uioh.patch added to -mm tree
Date: Thu, 17 May 2007 11:40:43 -0700
Message-ID: <200705171840.l4HIehFn030211@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbXEQSm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, greg@kroah.com


The patch titled
     remove odd and misleading comments from uio.h
has been added to the -mm tree.  Its filename is
     remove-odd-and-misleading-comments-from-uioh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove odd and misleading comments from uio.h
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uio.h |    9 ---------
 1 files changed, 9 deletions(-)

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

remove-slab_ctor_constructor.patch
git-avr32.patch
remove-odd-and-misleading-comments-from-uioh.patch
saa7134-tvaudio-kthread-conversion.patch
git-ia64.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
git-nfs.patch
cpci_hotplug-convert-to-use-the-kthread-api.patch
git-sh.patch
git-scsi-rc-fixes.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
vxfs-warning-fixes.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code-tidyups-update.patch
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
