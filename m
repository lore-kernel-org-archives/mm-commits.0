From: akpm@linux-foundation.org
Subject: + mm-page_isolationc-fix-the-function-comments.patch added to -mm tree
Date: Tue, 29 Mar 2016 12:50:57 -0700
Message-ID: <56fadca1.jKeFPo+/9+V16ibD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbcC2Tu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Mar 2016 15:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilzhang1123@hotmail.com, js1304@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation.c: fix the function comments
has been added to the -mm tree.  Its filename is
     mm-page_isolationc-fix-the-function-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolationc-fix-the-function-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolationc-fix-the-function-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Neil Zhang <neilzhang1123@hotmail.com>
Subject: mm/page_isolation.c: fix the function comments

commit fea85cff11de ("mm/page_isolation.c: return last tested pfn rather
than failure indicator") changed the meaning of the return value.
Let's change the function comments as well.

Signed-off-by: Neil Zhang <neilzhang1123@hotmail.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_isolation.c~mm-page_isolationc-fix-the-function-comments mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolationc-fix-the-function-comments
+++ a/mm/page_isolation.c
@@ -215,7 +215,7 @@ int undo_isolate_page_range(unsigned lon
  * all pages in [start_pfn...end_pfn) must be in the same zone.
  * zone->lock must be held before call this.
  *
- * Returns 1 if all pages in the range are isolated.
+ * Returns the last tested pfn.
  */
 static unsigned long
 __test_page_isolated_in_pageblock(unsigned long pfn, unsigned long end_pfn,
_

Patches currently in -mm which might be from neilzhang1123@hotmail.com are

mm-page_isolationc-fix-the-function-comments.patch

