From: akpm@linux-foundation.org
Subject: +
 mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix.patch added
 to -mm tree
Date: Thu, 23 May 2013 16:11:48 -0700
Message-ID: <519ea234.1EUhPSQw0nDKX+R1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759759Ab3EWXLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 19:11:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, aneesh.kumar@linux.vnet.ibm.com

Subject: + mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix.patch added to -mm tree
To: aneesh.kumar@linux.vnet.ibm.com,fengguang.wu@intel.com
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 16:11:48 -0700


The patch titled
     Subject: mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix
has been added to the -mm tree.  Its filename is
     mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------

Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
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
@@ -1351,7 +1351,7 @@ static inline pmd_t pmd_mkwrite(pmd_t pm
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
 #define __HAVE_ARCH_PGTABLE_DEPOSIT
-extern void pgtable_trans_huge_deposit(struct mm_struct *mm, , pmd_t *pmdp,
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				       pgtable_t pgtable);
 
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-thp-use-pmd_populate-to-update-the-pmd-with-pgtable_t-pointer.patch
mm-thp-use-the-right-function-when-updating-access-flags.patch
mm-thp-add-pmd-args-to-pgtable-deposit-and-withdraw-apis.patch
mm-thp-withdraw-the-pgtable-after-pmdp-related-operations.patch
mm-thp-withdraw-the-pgtable-after-pmdp-related-operations-fix.patch
mm-thp-dont-use-hpage_shift-in-transparent-hugepage-code.patch
mm-thp-deposit-the-transpare-huge-pgtable-before-set_pmd.patch

