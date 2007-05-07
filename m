From: akpm@linux-foundation.org
Subject: + knfsd-trivial-makefile-cleanup.patch added to -mm tree
Date: Mon, 07 May 2007 16:08:34 -0700
Message-ID: <200705072308.l47N8YZH007837@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845AbXEGXIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 19:08:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, neilb@suse.de


The patch titled
     knfsd: trivial makefile cleanup
has been added to the -mm tree.  Its filename is
     knfsd-trivial-makefile-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 deletion(-)

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
git-powerpc.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
git-scsi-misc.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
move-die-notifier-handling-to-common-code.patch
remove-do_sync_file_range.patch
remove-artificial-software-max_loop-limit.patch
merge-compat_ioctlh-into-compat_ioctlc.patch
cleanup-compat-ioctl-handling.patch
remove-redundant-check-from-proc_setattr.patch
remove-redundant-check-from-proc_sys_setattr.patch
make-iunique-use-a-do-while-loop-rather-than-its-obscure-goto-loop.patch
check-privileges-before-setting-mount-propagation.patch
jbd-check-for-error-returned-by-kthread_create-on-creating-journal-thread.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
knfsd-trivial-makefile-cleanup.patch
aio-is-unlikely.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
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
