From: akpm@linux-foundation.org
Subject: +
 mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch added to -mm tree
Date: Wed, 10 Feb 2016 13:35:19 -0800
Message-ID: <56bbad17.cSrFiw7brDtiNfj0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbcBJVfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 16:35:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Vineet.Gupta1@synopsys.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, vgupta@synopsys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp: fix spellos in describing __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
has been added to the -mm tree.  Its filename is
     mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: mm,thp: fix spellos in describing __HAVE_ARCH_FLUSH_PMD_TLB_RANGE

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
+ * entire TLB if flush span is greater than a threshhold, which will
  * likely be true for a single huge page. Thus a single thp flush will
- * invalidate the entire TLB which is not desitable.
+ * invalidate the entire TLB which is not desirable.
  * e.g. see arch/arc: flush_pmd_tlb_range
  */
 #define flush_pmd_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
_

Patches currently in -mm which might be from Vineet.Gupta1@synopsys.com are

mmthp-khugepaged-call-pte-flush-at-the-time-of-collapse.patch
mmthp-fix-spellos-in-describing-__have_arch_flush_pmd_tlb_range.patch

