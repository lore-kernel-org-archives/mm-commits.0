From: akpm@linux-foundation.org
Subject: [folded-merged] mmnuma-reorganize-change_pmd_range-fix.patch
 removed from -mm tree
Date: Mon, 07 Apr 2014 14:56:59 -0700
Message-ID: <53431f2b.jXsSbGqlA+f1msMe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbaDGV5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 17:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, rientjes@google.com, riel@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] mmnuma-reorganize-change_pmd_range-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,riel@redhat.com,rientjes@google.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 14:56:59 -0700


The patch titled
     Subject: mmnuma-reorganize-change_pmd_range-fix
has been removed from the -mm tree.  Its filename was
     mmnuma-reorganize-change_pmd_range-fix.patch

This patch was dropped because it was folded into mmnuma-reorganize-change_pmd_range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmnuma-reorganize-change_pmd_range-fix

fix indenting, per David

Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mprotect.c~mmnuma-reorganize-change_pmd_range-fix mm/mprotect.c
--- a/mm/mprotect.c~mmnuma-reorganize-change_pmd_range-fix
+++ a/mm/mprotect.c
@@ -119,7 +119,7 @@ static inline unsigned long change_pmd_r
 
 		next = pmd_addr_end(addr, end);
 		if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
-				continue;
+			continue;
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
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

