From: akpm@linux-foundation.org
Subject: [merged] flex_array-fix-flex_array_free_parts-comment.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:12 -0700
Message-ID: <200908271918.n7RJIClF009836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbZH0TSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     flex_array: fix flex_array_free_parts comment
has been removed from the -mm tree.  Its filename was
     flex_array-fix-flex_array_free_parts-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: fix flex_array_free_parts comment
From: David Rientjes <rientjes@google.com>

flex_array_free_parts() does not take `src' or `element_nr' formals, so
remove their respective comments.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_array.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN lib/flex_array.c~flex_array-fix-flex_array_free_parts-comment lib/flex_array.c
--- a/lib/flex_array.c~flex_array-fix-flex_array_free_parts-comment
+++ a/lib/flex_array.c
@@ -122,9 +122,6 @@ static int fa_element_to_part_nr(struct 
 
 /**
  * flex_array_free_parts - just free the second-level pages
- * @src:	address of data to copy into the array
- * @element_nr:	index of the position in which to insert
- * 		the new element.
  *
  * This is to be used in cases where the base 'struct flex_array'
  * has been statically allocated and should not be free.
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
flex_array-add-flex_array_clear-function.patch
flex_array-poison-free-elements.patch
flex_array-add-flex_array_shrink-function.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

