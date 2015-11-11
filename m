From: akpm@linux-foundation.org
Subject: [merged] hugetlb-trivial-comment-fix.patch removed from -mm tree
Date: Wed, 11 Nov 2015 11:48:09 -0800
Message-ID: <56439b79.m8WAmVR2e59icLS2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbKKTsJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 14:48:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: trivial comment fix
has been removed from the -mm tree.  Its filename was
     hugetlb-trivial-comment-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hugetlb: trivial comment fix

Recently alloc_buddy_huge_page() was renamed to __alloc_buddy_huge_page(),
so let's sync comments.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-trivial-comment-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-trivial-comment-fix
+++ a/mm/hugetlb.c
@@ -2138,7 +2138,7 @@ static unsigned long set_max_huge_pages(
 	 * First take pages out of surplus state.  Then make up the
 	 * remaining difference by allocating fresh huge pages.
 	 *
-	 * We might race with alloc_buddy_huge_page() here and be unable
+	 * We might race with __alloc_buddy_huge_page() here and be unable
 	 * to convert a surplus huge page to a normal huge page. That is
 	 * not critical, though, it just means the overall size of the
 	 * pool might be one hugepage larger than it needs to be, but
@@ -2180,7 +2180,7 @@ static unsigned long set_max_huge_pages(
 	 * By placing pages into the surplus state independent of the
 	 * overcommit value, we are allowing the surplus pool size to
 	 * exceed overcommit. There are few sane options here. Since
-	 * alloc_buddy_huge_page() is checking the global counter,
+	 * __alloc_buddy_huge_page() is checking the global counter,
 	 * though, we'll note that we're not allowed to exceed surplus
 	 * and won't grow the pool anywhere else. Not until one of the
 	 * sysctls are changed, or the surplus pages go out of use.
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hwpoison-adjust-for-new-thp-refcounting.patch

