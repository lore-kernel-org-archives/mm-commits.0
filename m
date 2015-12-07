From: akpm@linux-foundation.org
Subject: +
 arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch added to -mm tree
Date: Mon, 07 Dec 2015 15:31:29 -0800
Message-ID: <566616d1.wvJPoPY3OMGYqLIG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964891AbbLGXba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Dec 2015 18:31:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix
has been added to the -mm tree.  Its filename is
     arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix

Cc: Minchan Kim <minchan@kernel.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/uapi/asm/mman.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/mips/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -73,7 +73,6 @@
 #define MADV_SEQUENTIAL 2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
-#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_FREE	8		/* free pages only if memory pressure */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
oom-kill-init-lead-panic-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
mm-support-madvisemadv_free-fix-2-fix.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures-fix.patch
lib-vsprintfc-expand-field_width-to-24-bits-fix.patch
lib-test_printfc-test-dentry-printing-fix.patch
printk-help-pr_debug-and-pr_devel-to-optimize-out-arguments-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
ubsan-run-time-undefined-behavior-sanity-checker-fix.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

