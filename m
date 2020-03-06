From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?mm-numa-fix-bad-pmd-by-atomically-check-for-pmd=5Ftrans=5Fh?=
 =?US-ASCII?Q?uge-when-marking-page-tables-prot=5Fnuma-fix.patch?= removed
 from -mm tree
Date: Thu, 05 Mar 2020 22:24:06 -0800
Message-ID: <20200306062406.miPhDmN-Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgCFGYH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 01:24:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, vbabka@suse.cz, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix
has been removed from the -mm tree.  Its filename was
     mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix.patch

This patch was dropped because it was folded into mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix

fix comment typo, per Rafael

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa-fix
+++ a/mm/mprotect.c
@@ -209,7 +209,7 @@ static inline unsigned long change_pmd_r
 		 * held for read. It's possible a parallel update to occur
 		 * between pmd_trans_huge() and a pmd_none_or_clear_bad()
 		 * check leading to a false positive and clearing.
-		 * Hence, it's ecessary to atomically read the PMD value
+		 * Hence, it's necessary to atomically read the PMD value
 		 * for all the checks.
 		 */
 		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-numa-fix-bad-pmd-by-atomically-check-for-pmd_trans_huge-when-marking-page-tables-prot_numa.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
