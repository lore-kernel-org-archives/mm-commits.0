From: akpm@linux-foundation.org
Subject: [nacked]
 fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch removed
 from -mm tree
Date: Tue, 12 Aug 2014 12:28:49 -0700
Message-ID: <53ea6af1.wMP7Oa0W+ZhPNV//%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:54962 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaHLT2u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:28:50 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so1306053yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:28:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nilfs2/super.c: remove unnecessary test on unsigned value
has been removed from the -mm tree.  Its filename was
     fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/nilfs2/super.c: remove unnecessary test on unsigned value

Unsigned value is never < 0.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/super.c~fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value
+++ a/fs/nilfs2/super.c
@@ -1014,7 +1014,7 @@ int nilfs_checkpoint_is_mounted(struct s
 	struct dentry *dentry;
 	int ret;
 
-	if (cno < 0 || cno > nilfs->ns_cno)
+	if (cno > nilfs->ns_cno)
 		return false;
 
 	if (cno >= nilfs_last_cno(nilfs))
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
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
init-mainc-code-clean-up.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

