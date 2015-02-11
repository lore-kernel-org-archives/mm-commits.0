From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch removed from -mm tree
Date: Wed, 11 Feb 2015 15:12:58 -0800
Message-ID: <54dbe1fa.WJqXOktd4f66ux+p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbBKXM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nao.horiguchi@gmail.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch

This patch was dropped because it was folded into mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch

------------------------------------------------------
From: Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix

Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -716,7 +716,7 @@ follow_huge_pmd(struct mm_struct *mm, un
 
 struct page *
 follow_huge_pud(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
+		pud_t *pud, int write)
 {
 	BUG();
 	return NULL;
_

Patches currently in -mm which might be from nao.horiguchi@gmail.com are

mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch

