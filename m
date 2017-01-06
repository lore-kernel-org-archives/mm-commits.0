From: akpm@linux-foundation.org
Subject: + mm-fix-filemapc-kernel-doc-warnings.patch added to -mm tree
Date: Thu, 05 Jan 2017 16:54:30 -0800
Message-ID: <586eeac6.GhOVWv6ANbY1IdMp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36256 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbdAFAxM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 19:53:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix filemap.c kernel-doc warnings
has been added to the -mm tree.  Its filename is
     mm-fix-filemapc-kernel-doc-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-filemapc-kernel-doc-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-filemapc-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-filemapc-kernel-doc-warnings.patch

