From: akpm@linux-foundation.org
Subject: [folded-merged] mm-uninline-page_mapped-checkpatch-fixes.patch
 removed from -mm tree
Date: Thu, 19 May 2016 16:47:33 -0700
Message-ID: <573e5095.lUJ8XWz7bYxaVvQA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbcESXre (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:47:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-uninline-page_mapped-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-uninline-page_mapped-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-uninline-page_mapped.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-uninline-page_mapped-checkpatch-fixes

WARNING: Missing a blank line after declarations
#61: FILE: mm/util.c:356:
+	int i;
+	if (likely(!PageCompound(page)))

total: 0 errors, 1 warnings, 55 lines checked

./patches/mm-uninline-page_mapped.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/util.c~mm-uninline-page_mapped-checkpatch-fixes mm/util.c
--- a/mm/util.c~mm-uninline-page_mapped-checkpatch-fixes
+++ a/mm/util.c
@@ -353,6 +353,7 @@ void *page_rmapping(struct page *page)
 bool page_mapped(struct page *page)
 {
 	int i;
+
 	if (likely(!PageCompound(page)))
 		return atomic_read(&page->_mapcount) >= 0;
 	page = compound_head(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-nodemaskh-create-next_node_in-helper.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

