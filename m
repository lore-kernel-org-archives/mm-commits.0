From: akpm@linux-foundation.org
Subject: +
 filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch added to -mm tree
Date: Tue, 15 Nov 2016 16:11:30 -0800
Message-ID: <582ba432.BWPghZc73haGUTUq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752263AbcKPALb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2016 19:11:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jack@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix
has been added to the -mm tree.  Its filename is
     filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch

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
Subject: filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix

tweak comment

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix mm/filemap.c
--- a/mm/filemap.c~filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix
+++ a/mm/filemap.c
@@ -171,7 +171,7 @@ static void page_cache_tree_delete(struc
 {
 	int i, nr;
 
-	/* hugetlb pages represented by one entry on radix-tree */
+	/* hugetlb pages are represented by one entry in the radix tree */
 	nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
mm-disable-numa-migration-faults-for-dax-vmas-fix.patch
filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

