From: akpm@linux-foundation.org
Subject: [merged]
 asm-gemeric-tlb-remove-stray-function-declarations.patch removed from -mm
 tree
Date: Tue, 04 Feb 2020 10:42:07 -0800
Message-ID: <20200204184207.sRQHIwEJ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727551AbgBDSmH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:42:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, peterz@infradead.org


The patch titled
     Subject: asm-gemeric/tlb: remove stray function declarations
has been removed from the -mm tree.  Its filename was
     asm-gemeric-tlb-remove-stray-function-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: asm-gemeric/tlb: remove stray function declarations

We removed the actual functions a while ago.

Link: http://lkml.kernel.org/r/20200116064531.483522-5-aneesh.kumar@linux.ibm.com
Fixes: 1808d65b55e4 ("asm-generic/tlb: Remove arch_tlb*_mmu()")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    4 ----
 1 file changed, 4 deletions(-)

--- a/include/asm-generic/tlb.h~asm-gemeric-tlb-remove-stray-function-declarations
+++ a/include/asm-generic/tlb.h
@@ -285,11 +285,7 @@ struct mmu_gather {
 #endif
 };
 
-void arch_tlb_gather_mmu(struct mmu_gather *tlb,
-	struct mm_struct *mm, unsigned long start, unsigned long end);
 void tlb_flush_mmu(struct mmu_gather *tlb);
-void arch_tlb_finish_mmu(struct mmu_gather *tlb,
-			 unsigned long start, unsigned long end, bool force);
 
 static inline void __tlb_adjust_range(struct mmu_gather *tlb,
 				      unsigned long address,
_

Patches currently in -mm which might be from peterz@infradead.org are
