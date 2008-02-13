From: akpm@linux-foundation.org
Subject: - fix-up-kerneldoc-in-fs-ioctlc-a-little-bit.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:11 -0800
Message-ID: <200802132015.m1DKFBNu011283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35325 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756953AbYBMUPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ezk@cs.sunysb.edu, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     fix up kerneldoc in fs/ioctl.c a little bit
has been removed from the -mm tree.  Its filename was
     fix-up-kerneldoc-in-fs-ioctlc-a-little-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix up kerneldoc in fs/ioctl.c a little bit
From: Christoph Hellwig <hch@lst.de>

 - remove non-standard in/out markers
 - use tabs for formatting

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/ioctl.c~fix-up-kerneldoc-in-fs-ioctlc-a-little-bit fs/ioctl.c
--- a/fs/ioctl.c~fix-up-kerneldoc-in-fs-ioctlc-a-little-bit
+++ a/fs/ioctl.c
@@ -18,12 +18,12 @@
 
 /**
  * vfs_ioctl - call filesystem specific ioctl methods
- * @filp: [in]     open file to invoke ioctl method on
- * @cmd:  [in]     ioctl command to execute
- * @arg:  [in/out] command-specific argument for ioctl
+ * @filp:	open file to invoke ioctl method on
+ * @cmd:	ioctl command to execute
+ * @arg:	command-specific argument for ioctl
  *
  * Invokes filesystem specific ->unlocked_ioctl, if one exists; otherwise
- * invokes * filesystem specific ->ioctl method.  If neither method exists,
+ * invokes filesystem specific ->ioctl method.  If neither method exists,
  * returns -ENOTTY.
  *
  * Returns 0 on success, -errno on error.
_

Patches currently in -mm which might be from hch@lst.de are

git-unionfs.patch
git-xfs.patch
efs-move-headers-out-of-include-linux.patch
uml-update-defconfig.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
mxser-convert-large-macros-to-functions.patch
vfs-create-proc-pid-mountinfo.patch
reiserfs-use-open_bdev_excl.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
