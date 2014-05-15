From: akpm@linux-foundation.org
Subject: + zsmalloc-fixup-trivial-zs-size-classes-value-in-comments.patch
 added to -mm tree
Date: Thu, 15 May 2014 14:28:01 -0700
Message-ID: <53753161.ApRzlw+KEktOYnug%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaEOV2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 17:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, weijie.yang@samsung.com

Subject: + zsmalloc-fixup-trivial-zs-size-classes-value-in-comments.patch added to -mm tree
To: weijie.yang@samsung.com,minchan@kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 14:28:01 -0700


The patch titled
     Subject: zsmalloc: fixup trivial zs size classes value in comments
has been added to the -mm tree.  Its filename is
     zsmalloc-fixup-trivial-zs-size-classes-value-in-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-fixup-trivial-zs-size-classes-value-in-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-fixup-trivial-zs-size-classes-value-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: zsmalloc: fixup trivial zs size classes value in comments

According to calculation, ZS_SIZE_CLASSES value is 255 on systems with 4K
page size, not 254.  The old value may forget count the ZS_MIN_ALLOC_SIZE
in.

This patch fixes this trivial issue in the comments.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~zsmalloc-fixup-trivial-zs-size-classes-value-in-comments mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-fixup-trivial-zs-size-classes-value-in-comments
+++ a/mm/zsmalloc.c
@@ -141,7 +141,7 @@
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
 /*
- * On systems with 4K page size, this gives 254 size classes! There is a
+ * On systems with 4K page size, this gives 255 size classes! There is a
  * trader-off here:
  *  - Large number of size classes is potentially wasteful as free page are
  *    spread across these classes
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

zram-correct-offset-usage-in-zram_bio_discard.patch
zsmalloc-fixup-trivial-zs-size-classes-value-in-comments.patch

