Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B34A5C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93EE361402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhEHW4V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhEHW4U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FDBC610FA;
        Sat,  8 May 2021 22:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514518;
        bh=THksRQDKbvLnpd3QskQh7YGjj1yPgrcgMySBU6V8Zs8=;
        h=Date:From:To:Subject:From;
        b=xMEnTZ9oM61e2sDi2Q+iEz6iiA4qi50niK/3G3hqy7n68B9rmHfuxgbGQdPlMcrbD
         Th3KToouFZW/rNkqK6XH/LcsKF+mvBhLB3KN8MUi0NQ1w3QXSQ7+4K43YhWSlVxV7n
         4GyVnl5+rqUzrCyg6qa6jlXuWmqedjknbah3yRs4=
Date:   Sat, 08 May 2021 15:55:18 -0700
From:   akpm@linux-foundation.org
To:     mingo@kernel.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, unixbhaskar@gmail.com, willy@infradead.org
Subject:  [merged] mm-fix-typos-in-comments.patch removed from -mm
 tree
Message-ID: <20210508225518.Zv2hh6Qh4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix typos in comments
has been removed from the -mm tree.  Its filename was
     mm-fix-typos-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ingo Molnar <mingo@kernel.org>
Subject: mm: fix typos in comments

Fix ~94 single-word typos in locking code comments, plus a few
very obvious grammar mistakes.

Link: https://lkml.kernel.org/r/20210322212624.GA1963421@gmail.com
Link: https://lore.kernel.org/r/20210322205203.GB1959563@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h      |    2 +-
 include/linux/vmalloc.h |    4 ++--
 mm/balloon_compaction.c |    4 ++--
 mm/compaction.c         |    4 ++--
 mm/filemap.c            |    2 +-
 mm/gup.c                |    2 +-
 mm/highmem.c            |    2 +-
 mm/huge_memory.c        |    6 +++---
 mm/hugetlb.c            |    6 +++---
 mm/internal.h           |    2 +-
 mm/kasan/kasan.h        |    8 ++++----
 mm/kasan/quarantine.c   |    4 ++--
 mm/kasan/shadow.c       |    4 ++--
 mm/kfence/report.c      |    2 +-
 mm/khugepaged.c         |    2 +-
 mm/ksm.c                |    4 ++--
 mm/madvise.c            |    4 ++--
 mm/memcontrol.c         |   18 +++++++++---------
 mm/memory-failure.c     |    2 +-
 mm/memory.c             |   10 +++++-----
 mm/mempolicy.c          |    4 ++--
 mm/migrate.c            |    8 ++++----
 mm/mmap.c               |    4 ++--
 mm/mprotect.c           |    2 +-
 mm/mremap.c             |    2 +-
 mm/oom_kill.c           |    2 +-
 mm/page-writeback.c     |    4 ++--
 mm/page_alloc.c         |   14 +++++++-------
 mm/page_owner.c         |    2 +-
 mm/percpu-internal.h    |    2 +-
 mm/percpu.c             |    2 +-
 mm/pgalloc-track.h      |    6 +++---
 mm/slab.c               |    6 +++---
 mm/slub.c               |    2 +-
 mm/swap_slots.c         |    2 +-
 mm/vmalloc.c            |    6 +++---
 mm/vmstat.c             |    2 +-
 mm/zpool.c              |    2 +-
 mm/zsmalloc.c           |    2 +-
 39 files changed, 83 insertions(+), 83 deletions(-)

--- a/include/linux/mm.h~mm-fix-typos-in-comments
+++ a/include/linux/mm.h
@@ -106,7 +106,7 @@ extern int mmap_rnd_compat_bits __read_m
  * embedding these tags into addresses that point to these memory regions, and
  * checking that the memory and the pointer tags match on memory accesses)
  * redefine this macro to strip tags from pointers.
- * It's defined as noop for arcitectures that don't support memory tagging.
+ * It's defined as noop for architectures that don't support memory tagging.
  */
 #ifndef untagged_addr
 #define untagged_addr(addr) (addr)
--- a/include/linux/vmalloc.h~mm-fix-typos-in-comments
+++ a/include/linux/vmalloc.h
@@ -33,7 +33,7 @@ struct notifier_block;		/* in notifier.h
  *
  * If IS_ENABLED(CONFIG_KASAN_VMALLOC), VM_KASAN is set on a vm_struct after
  * shadow memory has been mapped. It's used to handle allocation errors so that
- * we don't try to poision shadow on free if it was never allocated.
+ * we don't try to poison shadow on free if it was never allocated.
  *
  * Otherwise, VM_KASAN is set for kasan_module_alloc() allocations and used to
  * determine which allocations need the module shadow freed.
@@ -43,7 +43,7 @@ struct notifier_block;		/* in notifier.h
 
 /*
  * Maximum alignment for ioremap() regions.
- * Can be overriden by arch-specific value.
+ * Can be overridden by arch-specific value.
  */
 #ifndef IOREMAP_MAX_ORDER
 #define IOREMAP_MAX_ORDER	(7 + PAGE_SHIFT)	/* 128 pages */
--- a/mm/balloon_compaction.c~mm-fix-typos-in-comments
+++ a/mm/balloon_compaction.c
@@ -58,7 +58,7 @@ EXPORT_SYMBOL_GPL(balloon_page_list_enqu
 /**
  * balloon_page_list_dequeue() - removes pages from balloon's page list and
  *				 returns a list of the pages.
- * @b_dev_info: balloon device decriptor where we will grab a page from.
+ * @b_dev_info: balloon device descriptor where we will grab a page from.
  * @pages: pointer to the list of pages that would be returned to the caller.
  * @n_req_pages: number of requested pages.
  *
@@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(balloon_page_enqueue);
 /*
  * balloon_page_dequeue - removes a page from balloon's page list and returns
  *			  its address to allow the driver to release the page.
- * @b_dev_info: balloon device decriptor where we will grab a page from.
+ * @b_dev_info: balloon device descriptor where we will grab a page from.
  *
  * Driver must call this function to properly dequeue a previously enqueued page
  * before definitively releasing it back to the guest system.
--- a/mm/compaction.c~mm-fix-typos-in-comments
+++ a/mm/compaction.c
@@ -2012,8 +2012,8 @@ static unsigned int fragmentation_score_
 	unsigned int wmark_low;
 
 	/*
-	 * Cap the low watermak to avoid excessive compaction
-	 * activity in case a user sets the proactivess tunable
+	 * Cap the low watermark to avoid excessive compaction
+	 * activity in case a user sets the proactiveness tunable
 	 * close to 100 (maximum).
 	 */
 	wmark_low = max(100U - sysctl_compaction_proactiveness, 5U);
--- a/mm/filemap.c~mm-fix-typos-in-comments
+++ a/mm/filemap.c
@@ -2755,7 +2755,7 @@ unsigned int seek_page_size(struct xa_st
  * entirely memory-based such as tmpfs, and filesystems which support
  * unwritten extents.
  *
- * Return: The requested offset on successs, or -ENXIO if @whence specifies
+ * Return: The requested offset on success, or -ENXIO if @whence specifies
  * SEEK_DATA and there is no data after @start.  There is an implicit hole
  * after @end - 1, so SEEK_HOLE returns @end if all the bytes between @start
  * and @end contain data.
--- a/mm/gup.c~mm-fix-typos-in-comments
+++ a/mm/gup.c
@@ -1575,7 +1575,7 @@ finish_or_fault:
  * Returns NULL on any kind of failure - a hole must then be inserted into
  * the corefile, to preserve alignment with its headers; and also returns
  * NULL wherever the ZERO_PAGE, or an anonymous pte_none, has been found -
- * allowing a hole to be left in the corefile to save diskspace.
+ * allowing a hole to be left in the corefile to save disk space.
  *
  * Called without mmap_lock (takes and releases the mmap_lock by itself).
  */
--- a/mm/highmem.c~mm-fix-typos-in-comments
+++ a/mm/highmem.c
@@ -519,7 +519,7 @@ void *__kmap_local_pfn_prot(unsigned lon
 
 	/*
 	 * Disable migration so resulting virtual address is stable
-	 * accross preemption.
+	 * across preemption.
 	 */
 	migrate_disable();
 	preempt_disable();
--- a/mm/huge_memory.c~mm-fix-typos-in-comments
+++ a/mm/huge_memory.c
@@ -1792,8 +1792,8 @@ bool move_huge_pmd(struct vm_area_struct
 /*
  * Returns
  *  - 0 if PMD could not be locked
- *  - 1 if PMD was locked but protections unchange and TLB flush unnecessary
- *  - HPAGE_PMD_NR is protections changed and TLB flush necessary
+ *  - 1 if PMD was locked but protections unchanged and TLB flush unnecessary
+ *  - HPAGE_PMD_NR if protections changed and TLB flush necessary
  */
 int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, pgprot_t newprot, unsigned long cp_flags)
@@ -2469,7 +2469,7 @@ static void __split_huge_page(struct pag
 		xa_lock(&swap_cache->i_pages);
 	}
 
-	/* lock lru list/PageCompound, ref freezed by page_ref_freeze */
+	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	lruvec = lock_page_lruvec(head);
 
 	for (i = nr - 1; i >= 1; i--) {
--- a/mm/hugetlb.c~mm-fix-typos-in-comments
+++ a/mm/hugetlb.c
@@ -466,7 +466,7 @@ static int allocate_file_region_entries(
 			      resv->region_cache_count;
 
 		/* At this point, we should have enough entries in the cache
-		 * for all the existings adds_in_progress. We should only be
+		 * for all the existing adds_in_progress. We should only be
 		 * needing to allocate for regions_needed.
 		 */
 		VM_BUG_ON(resv->region_cache_count < resv->adds_in_progress);
@@ -5536,8 +5536,8 @@ void adjust_range_if_pmd_sharing_possibl
 		v_end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
 
 	/*
-	 * vma need span at least one aligned PUD size and the start,end range
-	 * must at least partialy within it.
+	 * vma needs to span at least one aligned PUD size, and the range
+	 * must be at least partially within in.
 	 */
 	if (!(vma->vm_flags & VM_MAYSHARE) || !(v_end > v_start) ||
 		(*end <= v_start) || (*start >= v_end))
--- a/mm/internal.h~mm-fix-typos-in-comments
+++ a/mm/internal.h
@@ -334,7 +334,7 @@ static inline bool is_exec_mapping(vm_fl
 }
 
 /*
- * Stack area - atomatically grows in one direction
+ * Stack area - automatically grows in one direction
  *
  * VM_GROWSUP / VM_GROWSDOWN VMAs are always private anonymous:
  * do_mmap() forbids all other combinations.
--- a/mm/kasan/kasan.h~mm-fix-typos-in-comments
+++ a/mm/kasan/kasan.h
@@ -55,9 +55,9 @@ extern bool kasan_flag_async __ro_after_
 #define KASAN_TAG_MAX		0xFD /* maximum value for random tags */
 
 #ifdef CONFIG_KASAN_HW_TAGS
-#define KASAN_TAG_MIN		0xF0 /* mimimum value for random tags */
+#define KASAN_TAG_MIN		0xF0 /* minimum value for random tags */
 #else
-#define KASAN_TAG_MIN		0x00 /* mimimum value for random tags */
+#define KASAN_TAG_MIN		0x00 /* minimum value for random tags */
 #endif
 
 #ifdef CONFIG_KASAN_GENERIC
@@ -403,7 +403,7 @@ static inline bool kasan_byte_accessible
 #else /* CONFIG_KASAN_HW_TAGS */
 
 /**
- * kasan_poison - mark the memory range as unaccessible
+ * kasan_poison - mark the memory range as inaccessible
  * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
  * @size - range size, must be aligned to KASAN_GRANULE_SIZE
  * @value - value that's written to metadata for the range
@@ -434,7 +434,7 @@ bool kasan_byte_accessible(const void *a
 
 /**
  * kasan_poison_last_granule - mark the last granule of the memory range as
- * unaccessible
+ * inaccessible
  * @addr - range start address, must be aligned to KASAN_GRANULE_SIZE
  * @size - range size
  *
--- a/mm/kasan/quarantine.c~mm-fix-typos-in-comments
+++ a/mm/kasan/quarantine.c
@@ -27,7 +27,7 @@
 /* Data structure and operations for quarantine queues. */
 
 /*
- * Each queue is a signle-linked list, which also stores the total size of
+ * Each queue is a single-linked list, which also stores the total size of
  * objects inside of it.
  */
 struct qlist_head {
@@ -138,7 +138,7 @@ static void qlink_free(struct qlist_node
 		local_irq_save(flags);
 
 	/*
-	 * As the object now gets freed from the quaratine, assume that its
+	 * As the object now gets freed from the quarantine, assume that its
 	 * free track is no longer valid.
 	 */
 	*(u8 *)kasan_mem_to_shadow(object) = KASAN_KMALLOC_FREE;
--- a/mm/kasan/shadow.c~mm-fix-typos-in-comments
+++ a/mm/kasan/shadow.c
@@ -316,7 +316,7 @@ int kasan_populate_vmalloc(unsigned long
 	 * // rest of vmalloc process		<data dependency>
 	 * STORE p, a				LOAD shadow(x+99)
 	 *
-	 * If there is no barrier between the end of unpoisioning the shadow
+	 * If there is no barrier between the end of unpoisoning the shadow
 	 * and the store of the result to p, the stores could be committed
 	 * in a different order by CPU#0, and CPU#1 could erroneously observe
 	 * poison in the shadow.
@@ -384,7 +384,7 @@ static int kasan_depopulate_vmalloc_pte(
  * How does this work?
  * -------------------
  *
- * We have a region that is page aligned, labelled as A.
+ * We have a region that is page aligned, labeled as A.
  * That might not map onto the shadow in a way that is page-aligned:
  *
  *                    start                     end
--- a/mm/kfence/report.c~mm-fix-typos-in-comments
+++ a/mm/kfence/report.c
@@ -263,6 +263,6 @@ void kfence_report_error(unsigned long a
 	if (panic_on_warn)
 		panic("panic_on_warn set ...\n");
 
-	/* We encountered a memory unsafety error, taint the kernel! */
+	/* We encountered a memory safety error, taint the kernel! */
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_STILL_OK);
 }
--- a/mm/khugepaged.c~mm-fix-typos-in-comments
+++ a/mm/khugepaged.c
@@ -667,7 +667,7 @@ static int __collapse_huge_page_isolate(
 		 *
 		 * The page table that maps the page has been already unlinked
 		 * from the page table tree and this process cannot get
-		 * an additinal pin on the page.
+		 * an additional pin on the page.
 		 *
 		 * New pins can come later if the page is shared across fork,
 		 * but not from this process. The other process cannot write to
--- a/mm/ksm.c~mm-fix-typos-in-comments
+++ a/mm/ksm.c
@@ -1065,7 +1065,7 @@ static int write_protect_page(struct vm_
 		/*
 		 * Ok this is tricky, when get_user_pages_fast() run it doesn't
 		 * take any lock, therefore the check that we are going to make
-		 * with the pagecount against the mapcount is racey and
+		 * with the pagecount against the mapcount is racy and
 		 * O_DIRECT can happen right after the check.
 		 * So we clear the pte and flush the tlb before the check
 		 * this assure us that no O_DIRECT can happen after the check
@@ -1435,7 +1435,7 @@ static struct page *stable_node_dup(stru
 			 */
 			*_stable_node = found;
 			/*
-			 * Just for robustneess as stable_node is
+			 * Just for robustness, as stable_node is
 			 * otherwise left as a stable pointer, the
 			 * compiler shall optimize it away at build
 			 * time.
--- a/mm/madvise.c~mm-fix-typos-in-comments
+++ a/mm/madvise.c
@@ -799,7 +799,7 @@ static long madvise_dontneed_free(struct
 		if (end > vma->vm_end) {
 			/*
 			 * Don't fail if end > vma->vm_end. If the old
-			 * vma was splitted while the mmap_lock was
+			 * vma was split while the mmap_lock was
 			 * released the effect of the concurrent
 			 * operation may not cause madvise() to
 			 * have an undefined result. There may be an
@@ -1039,7 +1039,7 @@ process_madvise_behavior_valid(int behav
  *  MADV_DODUMP - cancel MADV_DONTDUMP: no longer exclude from core dump.
  *  MADV_COLD - the application is not expected to use this memory soon,
  *		deactivate pages in this range so that they can be reclaimed
- *		easily if memory pressure hanppens.
+ *		easily if memory pressure happens.
  *  MADV_PAGEOUT - the application is not expected to use this memory soon,
  *		page out the pages in this range immediately.
  *
--- a/mm/memcontrol.c~mm-fix-typos-in-comments
+++ a/mm/memcontrol.c
@@ -215,7 +215,7 @@ enum res_type {
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
 #define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
-/* Used for OOM nofiier */
+/* Used for OOM notifier */
 #define OOM_CONTROL		(0)
 
 /*
@@ -786,7 +786,7 @@ void __mod_lruvec_kmem_state(void *p, en
  * __count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
  * @idx: the event item
- * @count: the number of events that occured
+ * @count: the number of events that occurred
  */
 void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			  unsigned long count)
@@ -904,7 +904,7 @@ struct mem_cgroup *get_mem_cgroup_from_m
 	rcu_read_lock();
 	do {
 		/*
-		 * Page cache insertions can happen withou an
+		 * Page cache insertions can happen without an
 		 * actual mm context, e.g. during disk probing
 		 * on boot, loopback IO, acct() writes etc.
 		 */
@@ -1712,7 +1712,7 @@ static void mem_cgroup_unmark_under_oom(
 	struct mem_cgroup *iter;
 
 	/*
-	 * Be careful about under_oom underflows becase a child memcg
+	 * Be careful about under_oom underflows because a child memcg
 	 * could have been added after mem_cgroup_mark_under_oom.
 	 */
 	spin_lock(&memcg_oom_lock);
@@ -1884,7 +1884,7 @@ bool mem_cgroup_oom_synchronize(bool han
 		/*
 		 * There is no guarantee that an OOM-lock contender
 		 * sees the wakeups triggered by the OOM kill
-		 * uncharges.  Wake any sleepers explicitely.
+		 * uncharges.  Wake any sleepers explicitly.
 		 */
 		memcg_oom_recover(memcg);
 	}
@@ -4364,7 +4364,7 @@ void mem_cgroup_wb_stats(struct bdi_writ
  * Foreign dirty flushing
  *
  * There's an inherent mismatch between memcg and writeback.  The former
- * trackes ownership per-page while the latter per-inode.  This was a
+ * tracks ownership per-page while the latter per-inode.  This was a
  * deliberate design decision because honoring per-page ownership in the
  * writeback path is complicated, may lead to higher CPU and IO overheads
  * and deemed unnecessary given that write-sharing an inode across
@@ -4379,9 +4379,9 @@ void mem_cgroup_wb_stats(struct bdi_writ
  * triggering background writeback.  A will be slowed down without a way to
  * make writeback of the dirty pages happen.
  *
- * Conditions like the above can lead to a cgroup getting repatedly and
+ * Conditions like the above can lead to a cgroup getting repeatedly and
  * severely throttled after making some progress after each
- * dirty_expire_interval while the underyling IO device is almost
+ * dirty_expire_interval while the underlying IO device is almost
  * completely idle.
  *
  * Solving this problem completely requires matching the ownership tracking
@@ -5774,7 +5774,7 @@ static int mem_cgroup_can_attach(struct
 		return 0;
 
 	/*
-	 * We are now commited to this value whatever it is. Changes in this
+	 * We are now committed to this value whatever it is. Changes in this
 	 * tunable will only affect upcoming migrations, not the current one.
 	 * So we need to save it, and keep it going.
 	 */
--- a/mm/memory.c~mm-fix-typos-in-comments
+++ a/mm/memory.c
@@ -3727,7 +3727,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		return ret;
 
 	/*
-	 * Archs like ppc64 need additonal space to store information
+	 * Archs like ppc64 need additional space to store information
 	 * related to pte entry. Use the preallocated table for that.
 	 */
 	if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte) {
@@ -4503,7 +4503,7 @@ retry_pud:
 }
 
 /**
- * mm_account_fault - Do page fault accountings
+ * mm_account_fault - Do page fault accounting
  *
  * @regs: the pt_regs struct pointer.  When set to NULL, will skip accounting
  *        of perf event counters, but we'll still do the per-task accounting to
@@ -4512,9 +4512,9 @@ retry_pud:
  * @flags: the fault flags.
  * @ret: the fault retcode.
  *
- * This will take care of most of the page fault accountings.  Meanwhile, it
+ * This will take care of most of the page fault accounting.  Meanwhile, it
  * will also include the PERF_COUNT_SW_PAGE_FAULTS_[MAJ|MIN] perf counter
- * updates.  However note that the handling of PERF_COUNT_SW_PAGE_FAULTS should
+ * updates.  However, note that the handling of PERF_COUNT_SW_PAGE_FAULTS should
  * still be in per-arch page fault handlers at the entry of page fault.
  */
 static inline void mm_account_fault(struct pt_regs *regs,
@@ -4848,7 +4848,7 @@ out:
 /**
  * generic_access_phys - generic implementation for iomem mmap access
  * @vma: the vma to access
- * @addr: userspace addres, not relative offset within @vma
+ * @addr: userspace address, not relative offset within @vma
  * @buf: buffer to read/write
  * @len: length of transfer
  * @write: set to FOLL_WRITE when writing, otherwise reading
--- a/mm/memory-failure.c~mm-fix-typos-in-comments
+++ a/mm/memory-failure.c
@@ -75,7 +75,7 @@ static bool page_handle_poison(struct pa
 		if (dissolve_free_huge_page(page) || !take_page_off_buddy(page))
 			/*
 			 * We could fail to take off the target page from buddy
-			 * for example due to racy page allocaiton, but that's
+			 * for example due to racy page allocation, but that's
 			 * acceptable because soft-offlined page is not broken
 			 * and if someone really want to use it, they should
 			 * take it.
--- a/mm/mempolicy.c~mm-fix-typos-in-comments
+++ a/mm/mempolicy.c
@@ -1867,7 +1867,7 @@ static int apply_policy_zone(struct memp
 	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
 	 *
 	 * policy->v.nodes is intersect with node_states[N_MEMORY].
-	 * so if the following test faile, it implies
+	 * so if the following test fails, it implies
 	 * policy->v.nodes has movable memory only.
 	 */
 	if (!nodes_intersects(policy->v.nodes, node_states[N_HIGH_MEMORY]))
@@ -2098,7 +2098,7 @@ bool init_nodemask_of_mempolicy(nodemask
  *
  * If tsk's mempolicy is "default" [NULL], return 'true' to indicate default
  * policy.  Otherwise, check for intersection between mask and the policy
- * nodemask for 'bind' or 'interleave' policy.  For 'perferred' or 'local'
+ * nodemask for 'bind' or 'interleave' policy.  For 'preferred' or 'local'
  * policy, always return true since it may allocate elsewhere on fallback.
  *
  * Takes task_lock(tsk) to prevent freeing of its mempolicy.
--- a/mm/migrate.c~mm-fix-typos-in-comments
+++ a/mm/migrate.c
@@ -2779,11 +2779,11 @@ restore:
  *
  * For empty entries inside CPU page table (pte_none() or pmd_none() is true) we
  * do set MIGRATE_PFN_MIGRATE flag inside the corresponding source array thus
- * allowing the caller to allocate device memory for those unback virtual
- * address.  For this the caller simply has to allocate device memory and
+ * allowing the caller to allocate device memory for those unbacked virtual
+ * addresses.  For this the caller simply has to allocate device memory and
  * properly set the destination entry like for regular migration.  Note that
- * this can still fails and thus inside the device driver must check if the
- * migration was successful for those entries after calling migrate_vma_pages()
+ * this can still fail, and thus inside the device driver you must check if the
+ * migration was successful for those entries after calling migrate_vma_pages(),
  * just like for regular migration.
  *
  * After that, the callers must call migrate_vma_pages() to go over each entry
--- a/mm/mmap.c~mm-fix-typos-in-comments
+++ a/mm/mmap.c
@@ -612,7 +612,7 @@ static unsigned long count_vma_pages_ran
 	unsigned long nr_pages = 0;
 	struct vm_area_struct *vma;
 
-	/* Find first overlaping mapping */
+	/* Find first overlapping mapping */
 	vma = find_vma_intersection(mm, addr, end);
 	if (!vma)
 		return 0;
@@ -2875,7 +2875,7 @@ int __do_munmap(struct mm_struct *mm, un
 	if (unlikely(uf)) {
 		/*
 		 * If userfaultfd_unmap_prep returns an error the vmas
-		 * will remain splitted, but userland will get a
+		 * will remain split, but userland will get a
 		 * highly unexpected error anyway. This is no
 		 * different than the case where the first of the two
 		 * __split_vma fails, but we don't undo the first
--- a/mm/mprotect.c~mm-fix-typos-in-comments
+++ a/mm/mprotect.c
@@ -699,7 +699,7 @@ SYSCALL_DEFINE1(pkey_free, int, pkey)
 	mmap_write_unlock(current->mm);
 
 	/*
-	 * We could provie warnings or errors if any VMA still
+	 * We could provide warnings or errors if any VMA still
 	 * has the pkey set here.
 	 */
 	return ret;
--- a/mm/mremap.c~mm-fix-typos-in-comments
+++ a/mm/mremap.c
@@ -730,7 +730,7 @@ static unsigned long mremap_to(unsigned
 	 * So, to avoid such scenario we can pre-compute if the whole
 	 * operation has high chances to success map-wise.
 	 * Worst-scenario case is when both vma's (new_addr and old_addr) get
-	 * split in 3 before unmaping it.
+	 * split in 3 before unmapping it.
 	 * That means 2 more maps (1 for each) to the ones we already hold.
 	 * Check whether current map count plus 2 still leads us to 4 maps below
 	 * the threshold, otherwise return -ENOMEM here to be more safe.
--- a/mm/oom_kill.c~mm-fix-typos-in-comments
+++ a/mm/oom_kill.c
@@ -74,7 +74,7 @@ static inline bool is_memcg_oom(struct o
 
 #ifdef CONFIG_NUMA
 /**
- * oom_cpuset_eligible() - check task eligiblity for kill
+ * oom_cpuset_eligible() - check task eligibility for kill
  * @start: task struct of which task to consider
  * @oc: pointer to struct oom_control
  *
--- a/mm/page_alloc.c~mm-fix-typos-in-comments
+++ a/mm/page_alloc.c
@@ -893,7 +893,7 @@ compaction_capture(struct capture_contro
 		return false;
 
 	/*
-	 * Do not let lower order allocations polluate a movable pageblock.
+	 * Do not let lower order allocations pollute a movable pageblock.
 	 * This might let an unmovable request use a reclaimable pageblock
 	 * and vice-versa but no more than normal fallback logic which can
 	 * have trouble finding a high-order free page.
@@ -2776,7 +2776,7 @@ static bool unreserve_highatomic_pageblo
 			/*
 			 * In page freeing path, migratetype change is racy so
 			 * we can counter several free pages in a pageblock
-			 * in this loop althoug we changed the pageblock type
+			 * in this loop although we changed the pageblock type
 			 * from highatomic to ac->migratetype. So we should
 			 * adjust the count once.
 			 */
@@ -3080,7 +3080,7 @@ static void drain_local_pages_wq(struct
 	 * drain_all_pages doesn't use proper cpu hotplug protection so
 	 * we can race with cpu offline when the WQ can move this from
 	 * a cpu pinned worker to an unbound one. We can operate on a different
-	 * cpu which is allright but we also have to make sure to not move to
+	 * cpu which is alright but we also have to make sure to not move to
 	 * a different one.
 	 */
 	preempt_disable();
@@ -5929,7 +5929,7 @@ static int build_zonerefs_node(pg_data_t
 static int __parse_numa_zonelist_order(char *s)
 {
 	/*
-	 * We used to support different zonlists modes but they turned
+	 * We used to support different zonelists modes but they turned
 	 * out to be just not useful. Let's keep the warning in place
 	 * if somebody still use the cmd line parameter so that we do
 	 * not fail it silently
@@ -7670,7 +7670,7 @@ static void check_for_memory(pg_data_t *
 }
 
 /*
- * Some architecturs, e.g. ARC may have ZONE_HIGHMEM below ZONE_NORMAL. For
+ * Some architectures, e.g. ARC may have ZONE_HIGHMEM below ZONE_NORMAL. For
  * such cases we allow max_zone_pfn sorted in the descending order
  */
 bool __weak arch_has_descending_max_zone_pfns(void)
@@ -8728,7 +8728,7 @@ static int __alloc_contig_migrate_range(
  * alloc_contig_range() -- tries to allocate given range of pages
  * @start:	start PFN to allocate
  * @end:	one-past-the-last PFN to allocate
- * @migratetype:	migratetype of the underlaying pageblocks (either
+ * @migratetype:	migratetype of the underlying pageblocks (either
  *			#MIGRATE_MOVABLE or #MIGRATE_CMA).  All pageblocks
  *			in range must have the same migratetype and it must
  *			be either of the two.
@@ -8988,7 +8988,7 @@ EXPORT_SYMBOL(free_contig_range);
 
 /*
  * The zone indicated has a new number of managed_pages; batch sizes and percpu
- * page high values need to be recalulated.
+ * page high values need to be recalculated.
  */
 void __meminit zone_pcp_update(struct zone *zone)
 {
--- a/mm/page_owner.c~mm-fix-typos-in-comments
+++ a/mm/page_owner.c
@@ -233,7 +233,7 @@ void __copy_page_owner(struct page *oldp
 	/*
 	 * We don't clear the bit on the oldpage as it's going to be freed
 	 * after migration. Until then, the info can be useful in case of
-	 * a bug, and the overal stats will be off a bit only temporarily.
+	 * a bug, and the overall stats will be off a bit only temporarily.
 	 * Also, migrate_misplaced_transhuge_page() can still fail the
 	 * migration and then we want the oldpage to retain the info. But
 	 * in that case we also don't need to explicitly clear the info from
--- a/mm/page-writeback.c~mm-fix-typos-in-comments
+++ a/mm/page-writeback.c
@@ -1806,7 +1806,7 @@ pause:
 			break;
 
 		/*
-		 * In the case of an unresponding NFS server and the NFS dirty
+		 * In the case of an unresponsive NFS server and the NFS dirty
 		 * pages exceeds dirty_thresh, give the other good wb's a pipe
 		 * to go through, so that tasks on them still remain responsive.
 		 *
@@ -2216,7 +2216,7 @@ int write_cache_pages(struct address_spa
 			 * Page truncated or invalidated. We can freely skip it
 			 * then, even for data integrity operations: the page
 			 * has disappeared concurrently, so there could be no
-			 * real expectation of this data interity operation
+			 * real expectation of this data integrity operation
 			 * even if there is now a new, dirty page at the same
 			 * pagecache address.
 			 */
--- a/mm/percpu.c~mm-fix-typos-in-comments
+++ a/mm/percpu.c
@@ -1862,7 +1862,7 @@ fail:
 			pr_info("limit reached, disable warning\n");
 	}
 	if (is_atomic) {
-		/* see the flag handling in pcpu_blance_workfn() */
+		/* see the flag handling in pcpu_balance_workfn() */
 		pcpu_atomic_alloc_failed = true;
 		pcpu_schedule_balance_work();
 	} else {
--- a/mm/percpu-internal.h~mm-fix-typos-in-comments
+++ a/mm/percpu-internal.h
@@ -170,7 +170,7 @@ struct percpu_stats {
 	u64 nr_max_alloc;	/* max # of live allocations */
 	u32 nr_chunks;		/* current # of live chunks */
 	u32 nr_max_chunks;	/* max # of live chunks */
-	size_t min_alloc_size;	/* min allocaiton size */
+	size_t min_alloc_size;	/* min allocation size */
 	size_t max_alloc_size;	/* max allocation size */
 };
 
--- a/mm/pgalloc-track.h~mm-fix-typos-in-comments
+++ a/mm/pgalloc-track.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _LINUX_PGALLLC_TRACK_H
-#define _LINUX_PGALLLC_TRACK_H
+#ifndef _LINUX_PGALLOC_TRACK_H
+#define _LINUX_PGALLOC_TRACK_H
 
 #if defined(CONFIG_MMU)
 static inline p4d_t *p4d_alloc_track(struct mm_struct *mm, pgd_t *pgd,
@@ -48,4 +48,4 @@ static inline pmd_t *pmd_alloc_track(str
 	  (__pte_alloc_kernel(pmd) || ({*(mask)|=PGTBL_PMD_MODIFIED;0;})))?\
 		NULL: pte_offset_kernel(pmd, address))
 
-#endif /* _LINUX_PGALLLC_TRACK_H */
+#endif /* _LINUX_PGALLOC_TRACK_H */
--- a/mm/slab.c~mm-fix-typos-in-comments
+++ a/mm/slab.c
@@ -259,7 +259,7 @@ static void kmem_cache_node_init(struct
 
 #define BATCHREFILL_LIMIT	16
 /*
- * Optimization question: fewer reaps means less probability for unnessary
+ * Optimization question: fewer reaps means less probability for unnecessary
  * cpucache drain/refill cycles.
  *
  * OTOH the cpuarrays can contain lots of objects,
@@ -2381,8 +2381,8 @@ union freelist_init_state {
 };
 
 /*
- * Initialize the state based on the randomization methode available.
- * return true if the pre-computed list is available, false otherwize.
+ * Initialize the state based on the randomization method available.
+ * return true if the pre-computed list is available, false otherwise.
  */
 static bool freelist_state_initialize(union freelist_init_state *state,
 				struct kmem_cache *cachep,
--- a/mm/slub.c~mm-fix-typos-in-comments
+++ a/mm/slub.c
@@ -3403,7 +3403,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_bulk);
  */
 
 /*
- * Mininum / Maximum order of slab pages. This influences locking overhead
+ * Minimum / Maximum order of slab pages. This influences locking overhead
  * and slab fragmentation. A higher order reduces the number of partial slabs
  * and increases the number of allocations possible without having to
  * take the list_lock.
--- a/mm/swap_slots.c~mm-fix-typos-in-comments
+++ a/mm/swap_slots.c
@@ -16,7 +16,7 @@
  * to local caches without needing to acquire swap_info
  * lock.  We do not reuse the returned slots directly but
  * move them back to the global pool in a batch.  This
- * allows the slots to coaellesce and reduce fragmentation.
+ * allows the slots to coalesce and reduce fragmentation.
  *
  * The swap entry allocated is marked with SWAP_HAS_CACHE
  * flag in map_count that prevents it from being allocated
--- a/mm/vmalloc.c~mm-fix-typos-in-comments
+++ a/mm/vmalloc.c
@@ -1583,7 +1583,7 @@ static unsigned long lazy_max_pages(void
 static atomic_long_t vmap_lazy_nr = ATOMIC_LONG_INIT(0);
 
 /*
- * Serialize vmap purging.  There is no actual criticial section protected
+ * Serialize vmap purging.  There is no actual critical section protected
  * by this look, but we want to avoid concurrent calls for performance
  * reasons and to make the pcpu_get_vm_areas more deterministic.
  */
@@ -2628,7 +2628,7 @@ static void __vfree(const void *addr)
  * May sleep if called *not* from interrupt context.
  * Must not be called in NMI context (strictly speaking, it could be
  * if we have CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG, but making the calling
- * conventions for vfree() arch-depenedent would be a really bad idea).
+ * conventions for vfree() arch-dependent would be a really bad idea).
  */
 void vfree(const void *addr)
 {
@@ -3141,7 +3141,7 @@ static int aligned_vread(char *buf, char
 		/*
 		 * To do safe access to this _mapped_ area, we need
 		 * lock. But adding lock here means that we need to add
-		 * overhead of vmalloc()/vfree() calles for this _debug_
+		 * overhead of vmalloc()/vfree() calls for this _debug_
 		 * interface, rarely used. Instead of that, we'll use
 		 * kmap() and get small overhead in this access function.
 		 */
--- a/mm/vmstat.c~mm-fix-typos-in-comments
+++ a/mm/vmstat.c
@@ -934,7 +934,7 @@ void cpu_vm_stats_fold(int cpu)
 
 /*
  * this is only called if !populated_zone(zone), which implies no other users of
- * pset->vm_stat_diff[] exsist.
+ * pset->vm_stat_diff[] exist.
  */
 void drain_zonestat(struct zone *zone, struct per_cpu_pageset *pset)
 {
--- a/mm/zpool.c~mm-fix-typos-in-comments
+++ a/mm/zpool.c
@@ -336,7 +336,7 @@ int zpool_shrink(struct zpool *zpool, un
  * This may hold locks, disable interrupts, and/or preemption,
  * and the zpool_unmap_handle() must be called to undo those
  * actions.  The code that uses the mapped handle should complete
- * its operatons on the mapped handle memory quickly and unmap
+ * its operations on the mapped handle memory quickly and unmap
  * as soon as possible.  As the implementation may use per-cpu
  * data, multiple handles should not be mapped concurrently on
  * any cpu.
--- a/mm/zsmalloc.c~mm-fix-typos-in-comments
+++ a/mm/zsmalloc.c
@@ -1227,7 +1227,7 @@ EXPORT_SYMBOL_GPL(zs_get_total_pages);
  * zs_map_object - get address of allocated object from handle.
  * @pool: pool from which the object was allocated
  * @handle: handle returned from zs_malloc
- * @mm: maping mode to use
+ * @mm: mapping mode to use
  *
  * Before using an object allocated from zs_malloc, it must be mapped using
  * this function. When done with the object, it must be unmapped using
_

Patches currently in -mm which might be from mingo@kernel.org are


