From: akpm@linux-foundation.org
Subject: - knfsd-trivial-makefile-cleanup.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:16 -0700
Message-ID: <200705092153.l49LrGhA003073@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759265AbXEIVxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: trivial makefile cleanup
has been removed from the -mm tree.  Its filename was
     knfsd-trivial-makefile-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: trivial makefile cleanup
From: Christoph Hellwig <hch@lst.de>

kbuild directly interprets <modulename>-y as objects to build into a module,
no need to assign it to the old foo-objs variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/Makefile |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/nfsd/Makefile~knfsd-trivial-makefile-cleanup fs/nfsd/Makefile
--- a/fs/nfsd/Makefile~knfsd-trivial-makefile-cleanup
+++ a/fs/nfsd/Makefile
@@ -11,4 +11,3 @@ nfsd-$(CONFIG_NFSD_V3)	+= nfs3proc.o nfs
 nfsd-$(CONFIG_NFSD_V3_ACL) += nfs3acl.o
 nfsd-$(CONFIG_NFSD_V4)	+= nfs4proc.o nfs4xdr.o nfs4state.o nfs4idmap.o \
 			   nfs4acl.o nfs4callback.o nfs4recover.o
-nfsd-objs		:= $(nfsd-y)
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
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
