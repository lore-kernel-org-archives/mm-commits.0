From: akpm@linux-foundation.org
Subject: [folded-merged] mm-rename-page-struct-field-helpers-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:52:47 -0800
Message-ID: <20130222235248.5099531C1F9@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:48618 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BVXwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:52:49 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so121353vcd.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:52:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-page-struct-field-helpers-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-page-struct-field-helpers-fix.patch

This patch was dropped because it was folded into mm-rename-page-struct-field-helpers.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rename-page-struct-field-helpers-fix

fix zcache

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/zbud.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/zcache/zbud.c~mm-rename-page-struct-field-helpers-fix drivers/staging/zcache/zbud.c
--- a/drivers/staging/zcache/zbud.c~mm-rename-page-struct-field-helpers-fix
+++ a/drivers/staging/zcache/zbud.c
@@ -404,7 +404,7 @@ static inline struct page *zbud_unuse_zb
 	else
 		zbud_pers_pageframes--;
 	zbudpage_spin_unlock(zbudpage);
-	reset_page_mapcount(page);
+	page_mapcount_reset(page);
 	init_page_count(page);
 	page->index = 0;
 	return page;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove.patch
memory-hotplug-remove-page-table-of-x86_64-architecture.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch
page_alloc-add-movable_memmap-kernel-parameter.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-fast-hierarchy-aware-child-test.patch
mm-rename-page-struct-field-helpers.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch

