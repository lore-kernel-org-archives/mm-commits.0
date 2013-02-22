From: akpm@linux-foundation.org
Subject: [folded-merged] page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:44:11 -0800
Message-ID: <20130222234411.D1A1C5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:36227 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3BVXoM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:44:12 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so120475yhz.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:44:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch

This patch was dropped because it was folded into page_alloc-add-movable_memmap-kernel-parameter.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix

remove unneeded parens

Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix
+++ a/mm/page_alloc.c
@@ -5082,7 +5082,7 @@ early_param("kernelcore", cmdline_parse_
 early_param("movablecore", cmdline_parse_movablecore);
 
 /**
- * insert_movablecore_map() - Insert a memory range in to movablecore_map.map.
+ * insert_movablecore_map - Insert a memory range in to movablecore_map.map.
  * @start_pfn:	start pfn of the range
  * @end_pfn:	end pfn of the range
  *
@@ -5145,7 +5145,7 @@ static void __init insert_movablecore_ma
 }
 
 /**
- * movablecore_map_add_region() - Add a memory range into movablecore_map.
+ * movablecore_map_add_region - Add a memory range into movablecore_map.
  * @start:	physical start address of range
  * @end:	physical end address of range
  *
@@ -5174,7 +5174,7 @@ static void __init movablecore_map_add_r
 }
 
 /*
- * cmdline_parse_movablecore_map() - Parse boot option movablecore_map.
+ * cmdline_parse_movablecore_map - Parse boot option movablecore_map.
  * @p:	The boot option of the following format:
  *	movablecore_map=nn[KMG]@ss[KMG]
  *
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
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch

