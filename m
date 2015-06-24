From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:46:22 -0700
Message-ID: <558b414e.rFJlT6MVtn2Xd9Zi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbFXXqW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:46:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch

This patch was dropped because it was folded into mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix

fix CONFIG_HWPOISON_INJECT=m

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memory-failure.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix
+++ a/mm/memory-failure.c
@@ -946,6 +946,7 @@ int get_hwpoison_page(struct page *page)
 
 	return get_page_unless_zero(page);
 }
+EXPORT_SYMBOL_GPL(get_hwpoison_page);
 
 /*
  * Do all that is necessary to remove user space mappings. Unmap
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch
mm-new-mm-hook-framework.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch

