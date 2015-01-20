From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch added
 to -mm tree
Date: Tue, 20 Jan 2015 14:33:04 -0800
Message-ID: <54bed7a0.ax/6tp93M82J3mY2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbbATWdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 17:33:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nao.horiguchi@gmail.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_-fix.patch

