From: akpm@linux-foundation.org
Subject: [folded-merged]
 sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 25 Aug 2016 15:14:36 -0700
Message-ID: <57bf6dcc.tDWbIi5CIFkFGMkL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58993 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756471AbcHYWOh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 18:14:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, subashab@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes.patch

This patch was dropped because it was folded into sysctl-handle-error-writing-uint_max-to-u32-fields.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes

WARNING: A patch subject line should describe the change not the tool that found it
#2: 
Subject: sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes

WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#35: 
      mechanically convert to the typical style using --fix or --fix-inplace.

WARNING: please, no spaces at the start of a line
#60: FILE: kernel/sysctl.c:2277:
+    return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);$

WARNING: please, no spaces at the start of a line
#69: FILE: kernel/sysctl.c:2296:
+    return do_proc_dointvec(table, write, buffer, lenp, ppos,$

total: 0 errors, 4 warnings, 17 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/sysctl.c~sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes
+++ a/kernel/sysctl.c
@@ -2274,7 +2274,7 @@ static int do_proc_dointvec(struct ctl_t
 int proc_dointvec(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);
+	return do_proc_dointvec(table, write, buffer, lenp, ppos, NULL, NULL);
 }
 
 /**
@@ -2293,8 +2293,8 @@ int proc_dointvec(struct ctl_table *tabl
 int proc_douintvec(struct ctl_table *table, int write,
 		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-    return do_proc_dointvec(table, write, buffer, lenp, ppos,
-			    do_proc_douintvec_conv, NULL);
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+				do_proc_douintvec_conv, NULL);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

sysctl-handle-error-writing-uint_max-to-u32-fields.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes.patch
ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

