From: akpm@linux-foundation.org
Subject: + include-linux-gfph-spelling-fixes.patch added to -mm tree
Date: Mon, 10 May 2010 15:56:16 -0700
Message-ID: <201005102256.o4AMuGER027746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932836Ab0EJW4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 18:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mfmooney@gmail.com, error27@gmail.com, mfm@muteddisk.com


The patch titled
     include/linux/gfp.h: spelling fixes
has been added to the -mm tree.  Its filename is
     include-linux-gfph-spelling-fixes.patch

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
Subject: include/linux/gfp.h: spelling fixes
From: matt mooney <mfmooney@gmail.com>

Fix minor spelling errors in a few comments; no code changes.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/gfp.h~include-linux-gfph-spelling-fixes include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-gfph-spelling-fixes
+++ a/include/linux/gfp.h
@@ -15,7 +15,7 @@ struct vm_area_struct;
  * Zone modifiers (see linux/mmzone.h - low three bits)
  *
  * Do not put any conditional on these. If necessary modify the definitions
- * without the underscores and use the consistently. The definitions here may
+ * without the underscores and use them consistently. The definitions here may
  * be used in bit comparisons.
  */
 #define __GFP_DMA	((__force gfp_t)0x01u)
@@ -152,12 +152,12 @@ static inline int allocflags_to_migratet
  * GFP_ZONE_TABLE is a word size bitstring that is used for looking up the
  * zone to use given the lowest 4 bits of gfp_t. Entries are ZONE_SHIFT long
  * and there are 16 of them to cover all possible combinations of
- * __GFP_DMA, __GFP_DMA32, __GFP_MOVABLE and __GFP_HIGHMEM
+ * __GFP_DMA, __GFP_DMA32, __GFP_MOVABLE and __GFP_HIGHMEM.
  *
  * The zone fallback order is MOVABLE=>HIGHMEM=>NORMAL=>DMA32=>DMA.
  * But GFP_MOVABLE is not only a zone specifier but also an allocation
  * policy. Therefore __GFP_MOVABLE plus another zone selector is valid.
- * Only 1bit of the lowest 3 bit (DMA,DMA32,HIGHMEM) can be set to "1".
+ * Only 1 bit of the lowest 3 bits (DMA,DMA32,HIGHMEM) can be set to "1".
  *
  *       bit       result
  *       =================
@@ -197,7 +197,7 @@ static inline int allocflags_to_migratet
 )
 
 /*
- * GFP_ZONE_BAD is a bitmap for all combination of __GFP_DMA, __GFP_DMA32
+ * GFP_ZONE_BAD is a bitmap for all combinations of __GFP_DMA, __GFP_DMA32
  * __GFP_HIGHMEM and __GFP_MOVABLE that are not permitted. One flag per
  * entry starting with bit 0. Bit is set if the combination is not
  * allowed.
_

Patches currently in -mm which might be from mfmooney@gmail.com are

include-linux-gfph-spelling-fixes.patch
include-linux-gfph-fix-coding-style.patch

