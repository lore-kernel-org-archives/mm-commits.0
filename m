From: akpm@linux-foundation.org
Subject: + mm-fix-spelling-error.patch added to -mm tree
Date: Mon, 03 Apr 2017 15:31:14 -0700
Message-ID: <58e2cd32.7rXwstLnOlluriRp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdDCWbP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 18:31:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haolee.swjtu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix spelling error
has been added to the -mm tree.  Its filename is
     mm-fix-spelling-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-spelling-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-spelling-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hao Lee <haolee.swjtu@gmail.com>
Subject: mm: fix spelling error

Fix variable name error in comments. No code changes.

Link: http://lkml.kernel.org/r/20170403161655.5081-1-haolee.swjtu@gmail.com
Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-fix-spelling-error include/linux/gfp.h
--- a/include/linux/gfp.h~mm-fix-spelling-error
+++ a/include/linux/gfp.h
@@ -313,8 +313,8 @@ static inline bool gfpflags_allow_blocki
 
 /*
  * GFP_ZONE_TABLE is a word size bitstring that is used for looking up the
- * zone to use given the lowest 4 bits of gfp_t. Entries are ZONE_SHIFT long
- * and there are 16 of them to cover all possible combinations of
+ * zone to use given the lowest 4 bits of gfp_t. Entries are GFP_ZONES_SHIFT
+ * bits long and there are 16 of them to cover all possible combinations of
  * __GFP_DMA, __GFP_DMA32, __GFP_MOVABLE and __GFP_HIGHMEM.
  *
  * The zone fallback order is MOVABLE=>HIGHMEM=>NORMAL=>DMA32=>DMA.
_

Patches currently in -mm which might be from haolee.swjtu@gmail.com are

mm-fix-spelling-error.patch

