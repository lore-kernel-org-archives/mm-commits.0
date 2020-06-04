From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-test-get_count_order-long-in-test_bitopsc-fix.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 16:21:46 -0700
Message-ID: <20200604232146.XlmWVGLtP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXVs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, christian.brauner@ubuntu.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: lib-test-get_count_order-long-in-test_bitopsc-fix
has been removed from the -mm tree.  Its filename was
     lib-test-get_count_order-long-in-test_bitopsc-fix.patch

This patch was dropped because it was folded into lib-test-get_count_order-long-in-test_bitopsc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-test-get_count_order-long-in-test_bitopsc-fix

define local `i'

Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitops.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_bitops.c~lib-test-get_count_order-long-in-test_bitopsc-fix
+++ a/lib/test_bitops.c
@@ -50,6 +50,8 @@ unsigned long order_comb_long[][2] = {
 
 static int __init test_bitops_startup(void)
 {
+	int i;
+
 	pr_warn("Loaded test module\n");
 	set_bit(BITOPS_4, g_bitmap);
 	set_bit(BITOPS_7, g_bitmap);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-test-get_count_order-long-in-test_bitopsc.patch
seq_file-introduce-define_seq_attribute-helper-macro-checkpatch-fixes.patch
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
