From: akpm@linux-foundation.org
Subject: [merged] mm-ksmc-update-get_user_pages-in-comment.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:57:05 -0700
Message-ID: <20200408015705.omeSiZDKg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbgDHB5H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenli@uniontech.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ksm.c: update get_user_pages() argument in comment
has been removed from the -mm tree.  Its filename was
     mm-ksmc-update-get_user_pages-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Chen <chenli@uniontech.com>
Subject: mm/ksm.c: update get_user_pages() argument in comment

This updates get_user_pages()'s argument in ksm_test_exit()'s comment

Link: http://lkml.kernel.org/r/30ac2417-f1c7-f337-0beb-df561295298c@uniontech.com
Signed-off-by: Li Chen <chenli@uniontech.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksmc-update-get_user_pages-in-comment
+++ a/mm/ksm.c
@@ -455,7 +455,7 @@ static inline bool ksm_test_exit(struct
 /*
  * We use break_ksm to break COW on a ksm page: it's a stripped down
  *
- *	if (get_user_pages(addr, 1, 1, 1, &page, NULL) == 1)
+ *	if (get_user_pages(addr, 1, FOLL_WRITE, &page, NULL) == 1)
  *		put_page(page);
  *
  * but taking great care only to touch a ksm page, in a VM_MERGEABLE vma,
_

Patches currently in -mm which might be from chenli@uniontech.com are
