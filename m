From: akpm@google.com
Subject: + mm-fix-kunmap_high-comment.patch added to -mm tree
Date: Wed, 21 Sep 2011 16:24:24 -0700
Message-ID: <201109212324.p8LNOOSv001229@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:20427 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab1IUXY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2011 19:24:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: omycle@gmail.com


The patch titled
     Subject: mm: fix kunmap_high() comment
has been added to the -mm tree.  Its filename is
     mm-fix-kunmap_high-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Li Haifeng <omycle@gmail.com>
Subject: mm: fix kunmap_high() comment

Signed-off-by: Li Haifeng <omycle@gmail.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/highmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/highmem.c~mm-fix-kunmap_high-comment mm/highmem.c
--- a/mm/highmem.c~mm-fix-kunmap_high-comment
+++ a/mm/highmem.c
@@ -250,7 +250,7 @@ void *kmap_high_get(struct page *page)
 #endif
 
 /**
- * kunmap_high - map a highmem page into memory
+ * kunmap_high - unmap a highmem page into memory
  * @page: &struct page to unmap
  *
  * If ARCH_NEEDS_KMAP_HIGH_GET is not defined then this may be called
_
Subject: Subject: mm: fix kunmap_high() comment

Patches currently in -mm which might be from omycle@gmail.com are

mm-fix-kunmap_high-comment.patch

