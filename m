From: akpm@linux-foundation.org
Subject: [folded-merged]
 seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 16:23:36 -0700
Message-ID: <20200604232336.VOXfOId_Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXXj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:23:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com


The patch titled
     Subject: seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch

This patch was dropped because it was folded into seq_file-introduce-define_seq_attribute-helper-macro.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes

WARNING: suspect code indent for conditional statements (8, 24)
#43: FILE: include/linux/seq_file.h:152:
+	if (!ret && inode->i_private) {					\
+			struct seq_file *seq_f = file->private_data;	\

total: 0 errors, 1 warnings, 25 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/seq_file-introduce-define_seq_attribute-helper-macro.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/seq_file.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/seq_file.h~seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes
+++ a/include/linux/seq_file.h
@@ -150,8 +150,8 @@ static int __name ## _open(struct inode
 {									\
 	int ret = seq_open(file, &__name ## _sops);			\
 	if (!ret && inode->i_private) {					\
-			struct seq_file *seq_f = file->private_data;	\
-			seq_f->private = inode->i_private;		\
+		struct seq_file *seq_f = file->private_data;		\
+		seq_f->private = inode->i_private;			\
 	}								\
 	return ret;							\
 }									\
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

seq_file-introduce-define_seq_attribute-helper-macro.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-pre.patch
linux-next-rejects.patch
linux-next-post.patch
kernel-add-panic_on_taint-fix.patch
mm-consolidate-pgd_index-and-pgd_offset_k-definitions-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix.patch
mmap-locking-api-convert-mmap_sem-call-sites-missed-by-coccinelle-fix-fix-fix.patch
mmap-locking-api-rename-mmap_sem-to-mmap_lock-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix.patch
mmap-locking-api-convert-mmap_sem-comments-fix-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
maccess-unify-the-probe-kernel-arch-hooks-fix.patch
bpf-bpf_seq_printf-handle-potentially-unsafe-format-string-better.patch
maccess-always-use-strict-semantics-for-probe_kernel_read-fix.patch
x86-use-non-set_fs-based-maccess-routines-checkpatch-fixes.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
sh-convert-ins-outs-macros-to-inline-functions-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
