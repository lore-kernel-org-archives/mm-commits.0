From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 05/35] mm/page_alloc.c: fix kernel-doc warning
Date: Fri, 10 Apr 2020 14:32:29 -0700
Message-ID: <20200410213229.jtKWzx7Se%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVca (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:30 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, rdunlap@infradead.org, torvalds@linux-foundation.org

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
