From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch removed from -mm
 tree
Date: Mon, 07 Apr 2014 15:04:46 -0700
Message-ID: <534320fe.oEfKEHom4Q/lRAAn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaDGWEr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:04:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:04:46 -0700


The patch titled
     Subject: mm-per-thread-vma-caching-fix-6-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-per-thread-vma-caching.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-per-thread-vma-caching-fix-6-checkpatch-fixes

ERROR: code indent should use tabs where possible
#53: FILE: mm/vmacache.c:56:
+ ^I^Ireturn false;$

WARNING: please, no space before tabs
#53: FILE: mm/vmacache.c:56:
+ ^I^Ireturn false;$

WARNING: please, no spaces at the start of a line
#53: FILE: mm/vmacache.c:56:
+ ^I^Ireturn false;$

total: 1 errors, 2 warnings, 35 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-per-thread-vma-caching-fix-6.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmacache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmacache.c~mm-per-thread-vma-caching-fix-6-checkpatch-fixes mm/vmacache.c
--- a/mm/vmacache.c~mm-per-thread-vma-caching-fix-6-checkpatch-fixes
+++ a/mm/vmacache.c
@@ -53,7 +53,7 @@ static bool vmacache_valid(struct mm_str
 	 * nothing we can do here.
 	 */
 	if (!vmacache_valid_mm(mm))
- 		return false;
+		return false;
 
 	curr = current;
 	if (mm->vmacache_seqnum != curr->vmacache_seqnum) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
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

