From: akpm@linux-foundation.org
Subject: +
 mm-correct-comment-for-fullness-group-computation-in-zsmallocc.patch added
 to -mm tree
Date: Fri, 19 Sep 2014 15:33:08 -0700
Message-ID: <541caf24.l2bAeBDxSH3l/AsB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084AbaISWdJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 18:33:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shhuiw@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc.c: correct comment for fullness group computation
has been added to the -mm tree.  Its filename is
     mm-correct-comment-for-fullness-group-computation-in-zsmallocc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-correct-comment-for-fullness-group-computation-in-zsmallocc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-correct-comment-for-fullness-group-computation-in-zsmallocc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm/zsmalloc.c: correct comment for fullness group computation

The letter 'f' in "n <= N/f" stands for fullness_threshold_frac, not
1/fullness_threshold_frac.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-correct-comment-for-fullness-group-computation-in-zsmallocc mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-correct-comment-for-fullness-group-computation-in-zsmallocc
+++ a/mm/zsmalloc.c
@@ -175,7 +175,7 @@ enum fullness_group {
  *	n <= N / f, where
  * n = number of allocated objects
  * N = total number of objects zspage can store
- * f = 1/fullness_threshold_frac
+ * f = fullness_threshold_frac
  *
  * Similarly, we assign zspage to:
  *	ZS_ALMOST_FULL	when n > N / f
_

Patches currently in -mm which might be from shhuiw@gmail.com are

mm-correct-comment-for-fullness-group-computation-in-zsmallocc.patch

