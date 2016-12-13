From: akpm@linux-foundation.org
Subject: [folded-merged] mm-thp-page-cache-support-for-ppc64-fix.patch
 removed from -mm tree
Date: Mon, 12 Dec 2016 16:24:37 -0800
Message-ID: <584f3fc5.EQ4nNxIz1Wx/3Uus%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932221AbcLMAXx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:23:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-thp-page-cache-support-for-ppc64-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-page-cache-support-for-ppc64-fix.patch

This patch was dropped because it was folded into mm-thp-page-cache-support-for-ppc64.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-page-cache-support-for-ppc64-fix

remove unneeded parentheses, per Kirill

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-thp-page-cache-support-for-ppc64-fix mm/memory.c
--- a/mm/memory.c~mm-thp-page-cache-support-for-ppc64-fix
+++ a/mm/memory.c
@@ -3004,7 +3004,7 @@ out:
 	 * If we are going to fallback to pte mapping, do a
 	 * withdraw with pmd lock held.
 	 */
-	if (arch_needs_pgtable_deposit() && (ret == VM_FAULT_FALLBACK))
+	if (arch_needs_pgtable_deposit() && ret == VM_FAULT_FALLBACK)
 		fe->prealloc_pte = pgtable_trans_huge_withdraw(vma->vm_mm,
 							       fe->pmd);
 	spin_unlock(fe->ptl);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-thp-page-cache-support-for-ppc64.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch

