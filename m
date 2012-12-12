From: akpm@linux-foundation.org
Subject: [folded-merged] mm-memoryc-remove-unused-code-from-do_wp_page-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:41:48 -0800
Message-ID: <20121212214149.02C3382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:46428 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab2LLVlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:41:49 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so128857ggm.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:41:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dingel@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memoryc-remove-unused-code-from-do_wp_page-fix
has been removed from the -mm tree.  Its filename was
     mm-memoryc-remove-unused-code-from-do_wp_page-fix.patch

This patch was dropped because it was folded into mm-memoryc-remove-unused-code-from-do_wp_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memoryc-remove-unused-code-from-do_wp_page-fix

cleanup

Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/memory.c~mm-memoryc-remove-unused-code-from-do_wp_page-fix mm/memory.c
--- a/mm/memory.c~mm-memoryc-remove-unused-code-from-do_wp_page-fix
+++ a/mm/memory.c
@@ -2780,9 +2780,8 @@ unlock:
 oom_free_new:
 	page_cache_release(new_page);
 oom:
-	if (old_page) {
+	if (old_page)
 		page_cache_release(old_page);
-	}
 	return VM_FAULT_OOM;
 
 unwritable_page:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node.patch
mm-introduce-new-field-managed_pages-to-struct-zone.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning.patch
mm-memoryc-remove-unused-code-from-do_wp_page.patch

