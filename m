From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
 removed from -mm tree
Date: Mon, 07 Apr 2014 15:04:12 -0700
Message-ID: <534320dc.o+BK3By5JK7EA0DD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbaDGWEN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:04:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:04:12 -0700


The patch titled
     Subject: mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-add-debugfs-tunable-for-fault_around_order.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes

WARNING: Prefer pr_warn(... to pr_warning(...
#67: FILE: mm/memory.c:3376:
+		pr_warning("Failed to create fault_around_order in debugfs");

total: 0 errors, 1 warnings, 96 lines checked

./patches/mm-add-debugfs-tunable-for-fault_around_order.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes mm/memory.c
--- a/mm/memory.c~mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes
+++ a/mm/memory.c
@@ -3387,7 +3387,7 @@ static int __init fault_around_debugfs(v
 	ret = debugfs_create_file("fault_around_order",	0644, NULL, NULL,
 			&fault_around_order_fops);
 	if (!ret)
-		pr_warning("Failed to create fault_around_order in debugfs");
+		pr_warn("Failed to create fault_around_order in debugfs");
 	return 0;
 }
 late_initcall(fault_around_debugfs);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix-2.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

