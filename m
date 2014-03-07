From: akpm@linux-foundation.org
Subject: + mm-fix-coding-style.patch added to -mm tree
Date: Fri, 07 Mar 2014 15:06:04 -0800
Message-ID: <531a50dc.3xxZ3oWQw/X9haQB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaCGXGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2014 18:06:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yong@gnoy.org

Subject: + mm-fix-coding-style.patch added to -mm tree
To: yong@gnoy.org
From: akpm@linux-foundation.org
Date: Fri, 07 Mar 2014 15:06:04 -0800


The patch titled
     Subject: mm: fix coding style
has been added to the -mm tree.  Its filename is
     mm-fix-coding-style.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-coding-style.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-coding-style.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-fix-coding-style.patch

