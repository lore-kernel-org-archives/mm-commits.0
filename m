From: akpm@linux-foundation.org
Subject: + mm-swapc-make-functions-and-their-kernel-doc-agree-again.patch
 added to -mm tree
Date: Thu, 08 Feb 2018 11:54:00 -0800
Message-ID: <5a7caad8.lQJlrAiJ96oA8JWa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53482 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752179AbeBHTyB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 14:54:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, akpm@linux-foundation.org, rdunlap@infradead.org, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: make functions and their kernel-doc agree (again)
has been added to the -mm tree.  Its filename is
     mm-swapc-make-functions-and-their-kernel-doc-agree-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapc-make-functions-and-their-kernel-doc-agree-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapc-make-functions-and-their-kernel-doc-agree-again.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: mm/swap.c: make functions and their kernel-doc agree (again)

There was a conflict between the commit e02a9f048ef7 ("mm/swap.c: make
functions and their kernel-doc agree") and the commit f144c390f905 ("mm:
docs: fix parameter names mismatch") that both tried to fix mismatch
betweeen pagevec_lookup_entries() parameter names and their description.

Since nr_entries is a better name for the parameter, fix the description
again.

Link: http://lkml.kernel.org/r/1518116946-20947-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap.c~mm-swapc-make-functions-and-their-kernel-doc-agree-again mm/swap.c
--- a/mm/swap.c~mm-swapc-make-functions-and-their-kernel-doc-agree-again
+++ a/mm/swap.c
@@ -925,7 +925,7 @@ EXPORT_SYMBOL(__pagevec_lru_add);
  * @pvec:	Where the resulting entries are placed
  * @mapping:	The address_space to search
  * @start:	The starting entry index
- * @nr_pages:	The maximum number of pages
+ * @nr_entries:	The maximum number of pages
  * @indices:	The cache indices corresponding to the entries in @pvec
  *
  * pagevec_lookup_entries() will search for and return a group of up
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

mm-zpool-zpool_evictable-fix-mismatch-in-parameter-name-and-kernel-doc.patch
mm-swapc-make-functions-and-their-kernel-doc-agree-again.patch

