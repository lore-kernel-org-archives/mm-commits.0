From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 11 May 2020 14:22:34 -0700
Message-ID: <20200511212234.w0R2agGhi%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgEKVWf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 11 May 2020 17:22:35 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com


The patch titled
     Subject: seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-utilc-sysvipc_find_ipc-incorrectly-updates-position-index-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-slub-add-panic_on_error-to-the-debug-facilities-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-swapfilec-classify-swap_map_xxx-to-make-it-more-readable-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
arch-kunmap-remove-duplicate-kunmap-implementations-fix.patch
arch-kmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
arch-kunmap_atomic-consolidate-duplicate-code-checkpatch-fixes.patch
kmap-consolidate-kmap_prot-definitions-checkpatch-fixes.patch
mm-add-debug_wx-support-fix.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
linux-next-rejects.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
