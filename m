From: akpm@linux-foundation.org
Subject: + mm-introduce-memalloc_nofs_saverestore-api-fix.patch added to
 -mm tree
Date: Mon, 06 Mar 2017 13:26:20 -0800
Message-ID: <58bdd3fc.CHzO9B5vXtc6Y5Pi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932300AbdCFVfy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Mar 2017 16:35:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-introduce-memalloc_nofs_saverestore-api-fix
has been added to the -mm tree.  Its filename is
     mm-introduce-memalloc_nofs_saverestore-api-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-memalloc_nofs_saverestore-api-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-memalloc_nofs_saverestore-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3948,10 +3948,10 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
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

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
linux-next-rejects.patch
treewide-move-set_memory_-functions-away-from-cacheflushh-fix.patch
arm64-use-set_memoryh-header-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

