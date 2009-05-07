From: akpm@linux-foundation.org
Subject: [merged] doc-hashdist-defaults-on-for-64bit.patch removed from -mm tree
Date: Thu, 07 May 2009 12:15:52 -0700
Message-ID: <200905071915.n47JFq9x019927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbZEGTTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, davem@davemloft.net, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     doc: hashdist defaults on for 64bit
has been removed from the -mm tree.  Its filename was
     doc-hashdist-defaults-on-for-64bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: hashdist defaults on for 64bit
From: Hugh Dickins <hugh@veritas.com>

kernel boot parameter `hashdist' now defaults on for all 64bit NUMA.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~doc-hashdist-defaults-on-for-64bit Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~doc-hashdist-defaults-on-for-64bit
+++ a/Documentation/kernel-parameters.txt
@@ -775,7 +775,7 @@ and is between 256 and 4096 characters. 
 
 	hashdist=	[KNL,NUMA] Large hashes allocated during boot
 			are distributed across NUMA nodes.  Defaults on
-			for IA-64, off otherwise.
+			for 64bit NUMA, off otherwise.
 			Format: 0 | 1 (for off | on)
 
 	hcl=		[IA-64] SGI's Hardware Graph compatibility layer
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-disable-preemption-in-apply_to_pte_range.patch
integrity-nfsd-imbalance-bug-fix.patch
ksm-mmu_notifiers-add-set_pte_at_notify.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-page_wrprotect-write-protecting-page.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to.patch
ksm-add-ksm-kernel-shared-memory-driver.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-fix-unsafe-pte-fetching.patch
ksm-add-ksm-kernel-shared-memory-driver-limiting-the-num-of-mem-regions-user-can-register-per-fd.patch
ksm-add-ksm-kernel-shared-memory-driver-dont-allow-overlap-memory-addresses-registrations.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-ksm_remove_memory_region-ioctl.patch
ksm-add-ksm-kernel-shared-memory-driver-change-the-prot-handling-to-use-the-generic-helper-functions.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-follow_pte.patch
mm-use-generic-follow_pte-in-follow_phys.patch
mm-introduce-follow_pfn.patch
getrusage-fill-ru_maxrss-value.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
prio_tree-debugging-patch.patch

