From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes.patch
 removed from -mm tree
Date: Wed, 06 Sep 2017 16:01:12 -0700
Message-ID: <59b07e38.xiDyjN9+kqlupqXH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752422AbdIFXBN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:01:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-page_owner-make-init_pages_in_zone-faster.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes

WARNING: 'overlaping' may be misspelled - perhaps 'overlapping'?
#69: FILE: mm/page_owner.c:580:
+			/* Maybe overlaping zone */

total: 0 errors, 1 warnings, 60 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-page_owner-make-init_pages_in_zone-faster-fix.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_owner.c~mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-make-init_pages_in_zone-faster-fix-checkpatch-fixes
+++ a/mm/page_owner.c
@@ -577,7 +577,7 @@ static void init_pages_in_zone(pg_data_t
 			if (unlikely(!page_ext))
 				continue;
 
-			/* Maybe overlaping zone */
+			/* Maybe overlapping zone */
 			if (test_bit(PAGE_EXT_OWNER, &page_ext->flags))
 				continue;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_owner-make-init_pages_in_zone-faster.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
mmfork-introduce-madv_wipeonfork-fix.patch

