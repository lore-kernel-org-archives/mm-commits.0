From: akpm@linux-foundation.org
Subject: [folded-merged]
 filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch removed from -mm tree
Date: Mon, 12 Dec 2016 16:23:03 -0800
Message-ID: <584f3f67.Dpc7pwnw+X6LZ5gr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAWU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:22:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jack@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix
has been removed from the -mm tree.  Its filename was
     filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert-fix.patch

This patch was dropped because it was folded into filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch

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

filemap-add-comment-for-confusing-logic-in-page_cache_tree_insert.patch
include-linux-backing-dev-defsh-shrink-struct-backing_dev_info.patch
mm-add-vfree_atomic-fix-fix.patch
mm-thp-page-cache-support-for-ppc64-fix.patch
mm-rmap-handle-anon_vma_prepare-common-case-inline-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
init-reduce-rootwait-polling-interval-time-to-5ms-fix.patch

