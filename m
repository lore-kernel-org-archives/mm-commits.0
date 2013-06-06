From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix.patch removed from -mm tree
Date: Wed, 05 Jun 2013 17:13:14 -0700
Message-ID: <51afd41a.YTOKXuK6GazYqIsK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab3FFANP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 20:13:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, aneesh.kumar@linux.vnet.ibm.com

Subject: [folded-merged] mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix.patch removed from -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,fengguang.wu@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 17:13:14 -0700


The patch titled
     Subject: mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix.patch

This patch was dropped because it was folded into mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch

------------------------------------------------------
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix

s390: Fix build error

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/s390/include/asm/pgtable.h~mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix
+++ a/arch/s390/include/asm/pgtable.h
@@ -1348,7 +1348,7 @@ static inline pmd_t pmd_mkwrite(pmd_t pm
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
-extern void pgtable_trans_huge_deposit(struct mm_struct *mm, , pmd_t *pmdp,
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				       pgtable_t pgtable);
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
mm-thp-use-the-right-function-when-updating-access-flags.patch
mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis.patch
mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch
mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch
mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch

