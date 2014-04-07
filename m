From: akpm@linux-foundation.org
Subject: [folded-merged] mm-fix-coding-style.patch removed from -mm tree
Date: Mon, 07 Apr 2014 15:08:40 -0700
Message-ID: <534321e8.v2f2FoXnhczhdF5y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbaDGWIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:08:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yong@gnoy.org

Subject: [folded-merged] mm-fix-coding-style.patch removed from -mm tree
To: yong@gnoy.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:08:40 -0700


The patch titled
     Subject: mm: fix coding style
has been removed from the -mm tree.  Its filename was
     mm-fix-coding-style.patch

This patch was dropped because it was folded into mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch

------------------------------------------------------
From: Choi Gi-yong <yong@gnoy.org>
Subject: mm: fix coding style

Signed-off-by: Choi Gi-yong <yong@gnoy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-fix-coding-style mm/hugetlb.c
--- a/mm/hugetlb.c~mm-fix-coding-style
+++ a/mm/hugetlb.c
@@ -2898,8 +2898,7 @@ retry:
 	if (anon_rmap) {
 		ClearPagePrivate(page);
 		hugepage_add_new_anon_rmap(page, vma, address);
-	}
-	else
+	} else
 		page_dup_rmap(page);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
_

Patches currently in -mm which might be from yong@gnoy.org are

mm-fix-error-do-not-initialise-globals-to-0-or-null-and-coding-style.patch

