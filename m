From: akpm@linux-foundation.org
Subject: + doc-hashdist-defaults-on-for-64bit.patch added to -mm tree
Date: Fri, 01 May 2009 15:46:58 -0700
Message-ID: <200905012246.n41Mkw6U018176@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbZEAWt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2009 18:49:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, davem@davemloft.net, mel@csn.ul.ie


The patch titled
     doc: hashdist defaults on for 64bit
has been added to the -mm tree.  Its filename is
     doc-hashdist-defaults-on-for-64bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

doc-hashdist-defaults-on-for-64bit.patch
linux-next.patch
eliminate-thousands-of-warnings-with-gcc-32-build.patch
eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch
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
ksm-add-ksm-kernel-shared-memory-driver-borked-on-non-x86.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
getrusage-fill-ru_maxrss-value.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
prio_tree-debugging-patch.patch

