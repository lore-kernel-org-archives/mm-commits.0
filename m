From: akpm@linux-foundation.org
Subject: - ext2-remove-unused-ext2_put_inode-prototype.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:30 -0800
Message-ID: <200802082016.m18KGBVE010690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754911AbYBHUpg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:45:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     ext2: remove unused ext2_put_inode prototype
has been removed from the -mm tree.  Its filename was
     ext2-remove-unused-ext2_put_inode-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: remove unused ext2_put_inode prototype
From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ext2.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ext2/ext2.h~ext2-remove-unused-ext2_put_inode-prototype fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~ext2-remove-unused-ext2_put_inode-prototype
+++ a/fs/ext2/ext2.h
@@ -126,7 +126,6 @@ extern unsigned long ext2_count_free (st
 /* inode.c */
 extern struct inode *ext2_iget (struct super_block *, unsigned long);
 extern int ext2_write_inode (struct inode *, int);
-extern void ext2_put_inode (struct inode *);
 extern void ext2_delete_inode (struct inode *);
 extern int ext2_sync_inode (struct inode *);
 extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-unionfs.patch
git-xfs.patch
uml-update-defconfig.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
rename-open_namei-to-open_pathname.patch
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
vfs-create-proc-pid-mountinfo.patch
reiserfs-use-open_bdev_excl.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
