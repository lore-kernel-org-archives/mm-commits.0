From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-fix-kernel-doc-warning.patch
 removed from -mm tree
Date: Sat, 11 Apr 2020 23:44:39 -0700
Message-ID: <20200412064439.Yrt6ZFsnB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgDLGok (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, rdunlap@infradead.org


The patch titled
     Subject: mm/page_alloc.c: fix kernel-doc warning
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-kernel-doc-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/page_alloc.c: fix kernel-doc warning

Add description of function parameter 'mt' to fix kernel-doc warning:

../mm/page_alloc.c:3246: warning: Function parameter or member 'mt' not described in '__putback_isolated_page'

Link: http://lkml.kernel.org/r/02998bd4-0b82-2f15-2570-f86130304d1e@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_alloc.c~mm-page_alloc-fix-kernel-doc-warning
+++ a/mm/page_alloc.c
@@ -3224,6 +3224,7 @@ int __isolate_free_page(struct page *pag
  * __putback_isolated_page - Return a now-isolated page back where we got it
  * @page: Page that was isolated
  * @order: Order of the isolated page
+ * @mt: The page's pageblock's migratetype
  *
  * This function is meant to return a page pulled from the free lists via
  * __isolate_free_page back to the free lists they were pulled from.
_

Patches currently in -mm which might be from rdunlap@infradead.org are
