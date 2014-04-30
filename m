From: akpm@linux-foundation.org
Subject: + fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch added to -mm tree
Date: Wed, 30 Apr 2014 15:34:02 -0700
Message-ID: <53617a5a.Zy18l3oz9EbirQts%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759641AbaD3WeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Apr 2014 18:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shaggy@kernel.org, fabf@skynet.be

Subject: + fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch added to -mm tree
To: fabf@skynet.be,shaggy@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 15:34:02 -0700


The patch titled
     Subject: fs/jfs/jfs_logmgr.c: remove NULL assignment on static
has been added to the -mm tree.  Its filename is
     fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/jfs/jfs_logmgr.c: remove NULL assignment on static

Static values are automatically initialized to NULL

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Dave Kleikamp <shaggy@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_logmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jfs/jfs_logmgr.c~fs-jfs-jfs_logmgrc-remove-null-assignment-on-static fs/jfs/jfs_logmgr.c
--- a/fs/jfs/jfs_logmgr.c~fs-jfs-jfs_logmgrc-remove-null-assignment-on-static
+++ a/fs/jfs/jfs_logmgr.c
@@ -167,7 +167,7 @@ do {						\
  * Global list of active external journals
  */
 static LIST_HEAD(jfs_external_logs);
-static struct jfs_log *dummy_log = NULL;
+static struct jfs_log *dummy_log;
 static DEFINE_MUTEX(jfs_log_mutex);
 
 /*
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch

