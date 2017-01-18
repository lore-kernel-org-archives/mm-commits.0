From: akpm@linux-foundation.org
Subject: + mm-fix-linux-pagemaph-stray-kernel-doc-notation.patch added to
 -mm tree
Date: Wed, 18 Jan 2017 15:13:12 -0800
Message-ID: <587ff688.8kp8JzEL+l6M1ItO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54482 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751045AbdARXOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 18:14:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mawilcox@microsoft.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix <linux/pagemap.h> stray kernel-doc notation
has been added to the -mm tree.  Its filename is
     mm-fix-linux-pagemaph-stray-kernel-doc-notation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-linux-pagemaph-stray-kernel-doc-notation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-linux-pagemaph-stray-kernel-doc-notation.patch

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
Subject: mm: fix <linux/pagemap.h> stray kernel-doc notation

Delete stray (second) function description in find_lock_page() kernel-doc
notation.

Note: scripts/kernel-doc just ignores the second function description.

Fixes: 2457aec63745e ("mm: non-atomically mark page accessed during page cache allocation where possible")
Link: http://lkml.kernel.org/r/b037e9a3-516c-ec02-6c8e-fa5479747ba6@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/pagemap.h~mm-fix-linux-pagemaph-stray-kernel-doc-notation include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fix-linux-pagemaph-stray-kernel-doc-notation
+++ a/include/linux/pagemap.h
@@ -266,7 +266,6 @@ static inline struct page *find_get_page
 
 /**
  * find_lock_page - locate, pin and lock a pagecache page
- * pagecache_get_page - find and get a page reference
  * @mapping: the address_space to search
  * @offset: the page index
  *
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-fix-filemapc-kernel-doc-warnings.patch
mm-fix-linux-pagemaph-stray-kernel-doc-notation.patch
fonts-keep-non-sparc-fonts-listed-together.patch

