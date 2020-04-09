From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-fix-kernel-doc-warning.patch added to -mm
 tree
Date: Wed, 08 Apr 2020 17:39:37 -0700
Message-ID: <20200409003937.hMjk-wSOI%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgDIAjh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:39:37 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm/page_alloc.c: fix kernel-doc warning
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-kernel-doc-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-kernel-doc-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-kernel-doc-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/page_alloc.c: fix kernel-doc warning

Add description of function parameter 'mt' to fix kernel-doc warning:

../mm/page_alloc.c:3246: warning: Function parameter or member 'mt' not described in '__putback_isolated_page'

Link: http://lkml.kernel.org/r/02998bd4-0b82-2f15-2570-f86130304d1e@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
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

mm-page_alloc-fix-kernel-doc-warning.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t.patch
