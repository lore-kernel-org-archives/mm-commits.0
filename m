From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch removed from -mm tree
Date: Fri, 22 Feb 2013 15:51:41 -0800
Message-ID: <20130222235141.D9C525A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:58304 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918Ab3BVXvn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 18:51:43 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so136352qah.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 15:51:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, glommer@parallels.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix
has been removed from the -mm tree.  Its filename was
     memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch

This patch was dropped because it was folded into memcg-reduce-the-size-of-struct-memcg-244-fold.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix

oops

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix
+++ a/mm/memcontrol.c
@@ -363,7 +363,7 @@ struct mem_cgroup {
 	struct mem_cgroup_lru_info info;
 };
 
-static inline size_t memcg_size(void)
+static size_t memcg_size(void)
 {
 	return sizeof(struct mem_cgroup) +
 		nr_node_ids * sizeof(struct mem_cgroup_per_node);
@@ -381,7 +381,7 @@ enum {
 		((1 << KMEM_ACCOUNTED_ACTIVE) | (1 << KMEM_ACCOUNTED_ACTIVATED))
 
 #ifdef CONFIG_MEMCG_KMEM
-static void memcg_kmem_set_active(struct mem_cgroup *memcg)
+static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
 {
 	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
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
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch

