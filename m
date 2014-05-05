From: akpm@linux-foundation.org
Subject: + fs-reiserfs-streec-remove-obsolete-__constant.patch added to
 -mm tree
Date: Mon, 05 May 2014 13:59:46 -0700
Message-ID: <5367fbc2.KKJYmQv3CqMhAad3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbaEEU7q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 16:59:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jeffm@suse.com, fabf@skynet.be

Subject: + fs-reiserfs-streec-remove-obsolete-__constant.patch added to -mm tree
To: fabf@skynet.be,jeffm@suse.com
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 13:59:46 -0700


The patch titled
     Subject: fs/reiserfs/stree.c: remove obsolete __constant
has been added to the -mm tree.  Its filename is
     fs-reiserfs-streec-remove-obsolete-__constant.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-reiserfs-streec-remove-obsolete-__constant.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-reiserfs-streec-remove-obsolete-__constant.patch

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
Subject: fs/reiserfs/stree.c: remove obsolete __constant

__constant_cpu_to_le32 converted to cpu_to_le32

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/stree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/reiserfs/stree.c~fs-reiserfs-streec-remove-obsolete-__constant fs/reiserfs/stree.c
--- a/fs/reiserfs/stree.c~fs-reiserfs-streec-remove-obsolete-__constant
+++ a/fs/reiserfs/stree.c
@@ -228,10 +228,10 @@ const struct reiserfs_key MIN_KEY = { 0,
 
 /* Maximal possible key. It is never in the tree. */
 static const struct reiserfs_key MAX_KEY = {
-	__constant_cpu_to_le32(0xffffffff),
-	__constant_cpu_to_le32(0xffffffff),
-	{{__constant_cpu_to_le32(0xffffffff),
-	  __constant_cpu_to_le32(0xffffffff)},}
+	cpu_to_le32(0xffffffff),
+	cpu_to_le32(0xffffffff),
+	{{cpu_to_le32(0xffffffff),
+	  cpu_to_le32(0xffffffff)},}
 };
 
 /* Get delimiting key of the buffer by looking for it in the buffers in the path, starting from the bottom
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-affs-superc-bugfix-double-free.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch

