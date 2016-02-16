From: akpm@linux-foundation.org
Subject: [merged]
 mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch
 removed from -mm tree
Date: Tue, 16 Feb 2016 10:49:08 -0800
Message-ID: <56c36f24.n35iNMzBRYKgOUKQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbcBPStI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Feb 2016 13:49:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp: fix spellos in describing __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
has been removed from the -mm tree.  Its filename was
     mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: mm,thp: fix spellos in describing __HAVE_ARCH_FLUSH_PMD_TLB_RANGE

[akpm@linux-foundation.org: s/threshhold/threshold/]
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/pgtable-generic.c~mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range
+++ a/mm/pgtable-generic.c
@@ -90,9 +90,9 @@ pte_t ptep_clear_flush(struct vm_area_st
  * ARCHes with special requirements for evicting THP backing TLB entries can
  * implement this. Otherwise also, it can help optimize normal TLB flush in
  * THP regime. stock flush_tlb_range() typically has optimization to nuke the
- * entire TLB TLB if flush span is greater than a threshhold, which will
+ * entire TLB if flush span is greater than a threshold, which will
  * likely be true for a single huge page. Thus a single thp flush will
- * invalidate the entire TLB which is not desitable.
+ * invalidate the entire TLB which is not desirable.
  * e.g. see arch/arc: flush_pmd_tlb_range
  */
 #define flush_pmd_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

arc-thp-remove-infrastructure-for-handling-splitting-pmds.patch

