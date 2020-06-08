From: akpm@linux-foundation.org
Subject: [folded-merged] kernel-add-panic_on_taint-fix.patch
 removed from -mm tree
Date: Sun, 07 Jun 2020 21:17:36 -0700
Message-ID: <20200608041736.W7B3BWvNZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgFHERj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, cai@lca.pw, corbet@lwn.net, mcgrof@kernel.org, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: kernel-add-panic_on_taint-fix
has been removed from the -mm tree.  Its filename was
     kernel-add-panic_on_taint-fix.patch

This patch was dropped because it was folded into kernel-add-panic_on_taint.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-add-panic_on_taint-fix

tweak kernel-parameters.txt wording

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~kernel-add-panic_on_taint-fix
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3447,7 +3447,7 @@
 			bit 4: print ftrace buffer
 			bit 5: print all printk messages in buffer
 
-	panic_on_taint=	Bitmask for conditionally call panic() in add_taint()
+	panic_on_taint=	Bitmask for conditionally calling panic() in add_taint()
 			Format: <hex>[,nousertaint]
 			Hexadecimal bitmask representing the set of TAINT flags
 			that will cause the kernel to panic when add_taint() is
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-add-panic_on_taint.patch
doc-cgroup-update-note-about-conditions-when-oom-killer-is-invoked-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
ipc-convert-ipcs_idr-to-xarray-update-fix.patch
linux-next-git-rejects.patch
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
kernel-forkc-export-kernel_thread-to-modules.patch
