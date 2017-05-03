From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-introduce-memalloc_nofs_saverestore-api-fix.patch removed from -mm tree
Date: Wed, 03 May 2017 14:37:04 -0700
Message-ID: <590a4d80.654EZ+PUpcR/o+sm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45704 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdECVhF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-memalloc_nofs_saverestore-api-fix
has been removed from the -mm tree.  Its filename was
     mm-introduce-memalloc_nofs_saverestore-api-fix.patch

This patch was dropped because it was folded into mm-introduce-memalloc_nofs_saverestore-api.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-introduce-memalloc_nofs_saverestore-api-fix

fix comment typo, reflow comment

Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-introduce-memalloc_nofs_saverestore-api-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-memalloc_nofs_saverestore-api-fix
+++ a/mm/page_alloc.c
@@ -3951,10 +3951,10 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 		goto out;
 
 	/*
-	 * Apply scoped allocation constrains. This is mainly about
-	 * GFP_NOFS resp. GFP_NOIO which has to be inherited for all
-	 * allocation requests from a particular context which has
-	 * been marked by memalloc_no{fs,io}_{save,restore}
+	 * Apply scoped allocation constraints. This is mainly about GFP_NOFS
+	 * resp. GFP_NOIO which has to be inherited for all allocation requests
+	 * from a particular context which has been marked by
+	 * memalloc_no{fs,io}_{save,restore}.
 	 */
 	alloc_mask = current_gfp_context(gfp_mask);
 	ac.spread_dirty_pages = false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-memalloc_nofs_saverestore-api.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch

