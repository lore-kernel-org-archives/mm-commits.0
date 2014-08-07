From: akpm@linux-foundation.org
Subject: [merged] fs-logfs-readwritec-kernel-doc-warning-fixes.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:19 -0700
Message-ID: <53e3db4b.ZK9yQgrxcWGksETh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:43231 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaHGUCU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:20 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so838523obb.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, joern@logfs.org, prasadjoshi.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/logfs/readwrite.c: kernel-doc warning fixes
has been removed from the -mm tree.  Its filename was
     fs-logfs-readwritec-kernel-doc-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/logfs/readwrite.c: kernel-doc warning fixes

s/-/:/ and fix variable names.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joern Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/logfs/readwrite.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN fs/logfs/readwrite.c~fs-logfs-readwritec-kernel-doc-warning-fixes fs/logfs/readwrite.c
--- a/fs/logfs/readwrite.c~fs-logfs-readwritec-kernel-doc-warning-fixes
+++ a/fs/logfs/readwrite.c
@@ -1019,11 +1019,11 @@ static int __logfs_is_valid_block(struct
 /**
  * logfs_is_valid_block - check whether this block is still valid
  *
- * @sb	- superblock
- * @ofs	- block physical offset
- * @ino	- block inode number
- * @bix	- block index
- * @level - block level
+ * @sb:		superblock
+ * @ofs:	block physical offset
+ * @ino:	block inode number
+ * @bix:	block index
+ * @gc_level:	block level
  *
  * Returns 0 if the block is invalid, 1 if it is valid and 2 if it will
  * become invalid once the journal is written.
@@ -2226,10 +2226,9 @@ void btree_write_block(struct logfs_bloc
  *
  * @inode:		parent inode (ifile or directory)
  * @buf:		object to write (inode or dentry)
- * @n:			object size
- * @_pos:		object number (file position in blocks/objects)
+ * @count:		object size
+ * @bix:		block index
  * @flags:		write flags
- * @lock:		0 if write lock is already taken, 1 otherwise
  * @shadow_tree:	shadow below this inode
  *
  * FIXME: All caller of this put a 200-300 byte variable on the stack,
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
fs-efs-nameic-return-is-not-a-function.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-coda-use-linux-uaccessh.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-ufs-inodec-kernel-doc-warning-fixes.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-hpfs-dnodec-fix-suspect-code-indent.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
proc-constify-seq_operations.patch
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
fs-bfs-use-bfs-prefix-for-dump_imap.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cramfs-convert-printk-to-pr_foo.patch
fs-cramfs-use-pr_fmt.patch
fs-cramfs-code-clean-up.patch
fs-cramfs-inodec-use-linux-uaccessh.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
scripts-coccinelle-free-ifnullfreecocci-add-copyright-information.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

