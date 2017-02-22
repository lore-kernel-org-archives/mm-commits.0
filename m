From: akpm@linux-foundation.org
Subject: [patch 100/142] mm: fix filemap.c kernel-doc warnings
Date: Wed, 22 Feb 2017 15:44:44 -0800
Message-ID: <58ae226c.urcMEpISgFgIvXJH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49114 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934046AbdBVXop (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:44:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rdunlap@infradead.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm: fix filemap.c kernel-doc warnings

Fix kernel-doc warnings in mm/filemap.c:

..//mm/filemap.c:993: warning: No description found for parameter '__page'
..//mm/filemap.c:993: warning: Excess function parameter 'page' description in '__lock_page'

Link: http://lkml.kernel.org/r/a66fe492-518c-ad6c-5f03-5e8b721fb451@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-fix-filemapc-kernel-doc-warnings mm/filemap.c
--- a/mm/filemap.c~mm-fix-filemapc-kernel-doc-warnings
+++ a/mm/filemap.c
@@ -1019,7 +1019,7 @@ EXPORT_SYMBOL_GPL(page_endio);
 
 /**
  * __lock_page - get a lock on the page, assuming we need to sleep to get it
- * @page: the page to lock
+ * @__page: the page to lock
  */
 void __lock_page(struct page *__page)
 {
_
