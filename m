From: akpm@linux-foundation.org
Subject: [merged]
 fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 13:07:45 -0700
Message-ID: <5390ce11.3xw479dEJ27bRG2j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaFEUHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:07:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raven@themaw.net, fabf@skynet.be

Subject: [merged] fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch removed from -mm tree
To: fabf@skynet.be,raven@themaw.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:07:45 -0700


The patch titled
     Subject: fs/autofs4/dev-ioctl.c: add __init to autofs_dev_ioctl_init
has been removed from the -mm tree.  Its filename was
     fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/autofs4/dev-ioctl.c: add __init to autofs_dev_ioctl_init

autofs_dev_ioctl_init is only called by __init init_autofs4_fs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/dev-ioctl.c~fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init
+++ a/fs/autofs4/dev-ioctl.c
@@ -737,7 +737,7 @@ MODULE_ALIAS_MISCDEV(AUTOFS_MINOR);
 MODULE_ALIAS("devname:autofs");
 
 /* Register/deregister misc character device */
-int autofs_dev_ioctl_init(void)
+int __init autofs_dev_ioctl_init(void)
 {
 	int r;
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

