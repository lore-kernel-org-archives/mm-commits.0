From: akpm@linux-foundation.org
Subject: [merged] mm-fix-filemapc-kernel-doc-warnings.patch removed from
 -mm tree
Date: Thu, 23 Feb 2017 13:15:50 -0800
Message-ID: <58af5106.9614jHfv+/hJZypd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVPv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:15:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix filemap.c kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     mm-fix-filemapc-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are

fonts-keep-non-sparc-fonts-listed-together.patch

