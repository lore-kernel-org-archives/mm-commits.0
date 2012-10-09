From: akpm@linux-foundation.org
Subject: [merged] mm-memoryc-fix-typo-in-comment.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:26 -0700
Message-ID: <20121009181426.9B017100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:43458 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab2JISO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:27 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so519186qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix typo in comment
has been removed from the -mm tree.  Its filename was
     mm-memoryc-fix-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: mm/memory.c: fix typo in comment

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-fix-typo-in-comment mm/memory.c
--- a/mm/memory.c~mm-memoryc-fix-typo-in-comment
+++ a/mm/memory.c
@@ -2148,7 +2148,7 @@ out:
  * @addr: target user address of this page
  * @pfn: source kernel pfn
  *
- * Similar to vm_inert_page, this allows drivers to insert individual pages
+ * Similar to vm_insert_page, this allows drivers to insert individual pages
  * they've allocated into a user vma. Same comments apply.
  *
  * This function should only be called from a vm_ops->fault handler, and
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
linux-next.patch

