From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 22 Feb 2017 15:38:31 -0800
Message-ID: <20170222153831.ab751ffc50f367709ad3cb2e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47574 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933785AbdBVXic (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:38:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

142 patches, based on 37c85961c3f87f2141c84e53df31e59db072fd2e:

- DAX updates

- various misc bits

- OCFS2 updates

- most of MM

Subject: tracing: add __print_flags_u64()
Subject: dax: add tracepoint infrastructure, PMD tracing
Subject: dax: update MAINTAINERS entries for FS DAX
Subject: dax: add tracepoints to dax_pmd_load_hole()
Subject: dax: add tracepoints to dax_pmd_insert_mapping()
Subject: mm, dax: make pmd_fault() and friends be the same as fault()
Subject: mm, dax: change pmd_fault() to take only vmf parameter
Subject: dma-debug: add comment for failed to check map error
Subject: tools/vm: add missing Makefile rules
Subject: scripts/spelling.txt: add several more common spelling mistakes
Subject: scripts/spelling.txt: fix incorrect typo-words
Subject: scripts/Lindent: clean up and optimize
Subject: scripts/checkstack.pl: add support for nios2
Subject: scripts/checkincludes.pl: add exit message for no duplicates found
Subject: scripts/tags.sh: include arch/Kconfig* for tags generation
Subject: m32r: use generic current.h
Subject: m32r: fix build warning
Subject: score: remove asm/current.h
Subject: ocfs2/dlmglue: prepare tracking logic to avoid recursive cluster lock
Subject: ocfs2: fix deadlock issue when taking inode lock at vfs entry points
Subject: parisc: use generic current.h
Subject: block: use for_each_thread() in sys_ioprio_set()/sys_ioprio_get()
Subject: 9p: fix a potential acl leak
Subject: kernel/watchdog.c: do not hardcode CPU 0 as the initial thread
Subject: slub: do not merge cache if slub_debug contains a never-merge flag
Subject: mm/slub: add a dump_stack() to the unexpected GFP check
Subject: mm, slab: rename kmalloc-node cache to kmalloc-<size>
Subject: Revert "slub: move synchronize_sched out of slab_mutex on shrink"
Subject: slub: separate out sysfs_slab_release() from sysfs_slab_remove()
Subject: slab: remove synchronous rcu_barrier() call in memcg cache release path
Subject: slab: reorganize memcg_cache_params
Subject: slab: link memcg kmem_caches on their associated memory cgroup
Subject: slab: implement slab_root_caches list
Subject: slab: introduce __kmemcg_cache_deactivate()
Subject: slab: remove synchronous synchronize_sched() from memcg cache deactivation path
Subject: slab: remove slub sysfs interface files early for empty memcg caches
Subject: slab: use memcg_kmem_cache_wq for slab destruction operations
Subject: slub: make sysfs directories for memcg sub-caches optional
Subject: tmpfs: change shmem_mapping() to test shmem_aops
Subject: mm: throttle show_mem() from warn_alloc()
Subject: mm, page_alloc: don't convert pfn to idx when merging
Subject: mm, page_alloc: avoid page_to_pfn() when merging buddies
Subject: mm/vmalloc.c: use rb_entry_safe
Subject: mm, trace: extract COMPACTION_STATUS and ZONE_TYPE to a common header
Subject: oom, trace: add oom detection tracepoints
Subject: oom, trace: add compaction retry tracepoint
Subject: userfaultfd: document _IOR/_IOW
Subject: userfaultfd: correct comment about UFFD_FEATURE_PAGEFAULT_FLAG_WP
Subject: userfaultfd: convert BUG() to WARN_ON_ONCE()
Subject: userfaultfd: use vma_is_anonymous
Subject: userfaultfd: non-cooperative: Split the find_userfault() routine
Subject: userfaultfd: non-cooperative: add ability to report non-PF events from uffd descriptor
Subject: userfaultfd: non-cooperative: report all available features to userland
Subject: userfaultfd: non-cooperative: Add fork() event
Subject: userfaultfd: non-cooperative: dup_userfaultfd: use mm_count instead of mm_users
Subject: userfaultfd: non-cooperative: add mremap() event
Subject: userfaultfd: non-cooperative: optimize mremap_userfaultfd_complete()
Subject: userfaultfd: non-cooperative: add madvise() event for MADV_DONTNEED request
Subject: userfaultfd: non-cooperative: avoid MADV_DONTNEED race condition
Subject: userfaultfd: non-cooperative: wake userfaults after UFFDIO_UNREGISTER
Subject: userfaultfd: hugetlbfs: add copy_huge_page_from_user for hugetlb userfaultfd support
Subject: userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support
Subject: userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY
Subject: userfaultfd: hugetlbfs: fix __mcopy_atomic_hugetlb retry/error processing
Subject: userfaultfd: hugetlbfs: add userfaultfd hugetlb hook
Subject: userfaultfd: hugetlbfs: allow registration of ranges containing huge pages
Subject: userfaultfd: hugetlbfs: add userfaultfd_hugetlb test
Subject: userfaultfd: hugetlbfs: userfaultfd_huge_must_wait for hugepmd ranges
Subject: userfaultfd: hugetlbfs: gup: support VM_FAULT_RETRY
Subject: userfaultfd: hugetlbfs: reserve count on error in __mcopy_atomic_hugetlb
Subject: userfaultfd: hugetlbfs: UFFD_FEATURE_MISSING_HUGETLBFS
Subject: userfaultfd: introduce vma_can_userfault
Subject: userfaultfd: shmem: add shmem_mcopy_atomic_pte for userfaultfd support
Subject: userfaultfd: shmem: introduce vma_is_shmem
Subject: userfaultfd: shmem: add tlbflush.h header for microblaze
Subject: userfaultfd: shmem: use shmem_mcopy_atomic_pte for shared memory
Subject: userfaultfd: shmem: add userfaultfd hook for shared memory faults
Subject: userfaultfd: shmem: allow registration of shared memory ranges
Subject: userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings
Subject: userfaultfd: shmem: add userfaultfd_shmem test
Subject: userfaultfd: shmem: lock the page before adding it to pagecache
Subject: userfaultfd: shmem: avoid a lockup resulting from corrupted page->flags
Subject: userfaultfd: shmem: avoid leaking blocks and used blocks in UFFDIO_COPY
Subject: userfaultfd: hugetlbfs: UFFD_FEATURE_MISSING_SHMEM
Subject: userfaultfd: non-cooperative: selftest: introduce userfaultfd_open
Subject: userfaultfd: non-cooperative: selftest: add ufd parameter to copy_page
Subject: userfaultfd: non-cooperative: selftest: add test for FORK, MADVDONTNEED and REMAP events
Subject: userfaultfd: selftest: test UFFDIO_ZEROPAGE on all memory types
Subject: mm: mprotect: use pmd_trans_unstable instead of taking the pmd_lock
Subject: mm, vmscan: remove unused mm_vmscan_memcg_isolate
Subject: mm, vmscan: add active list aging tracepoint
Subject: mm, vmscan: show the number of skipped pages in mm_vmscan_lru_isolate
Subject: mm, vmscan: show LRU name in mm_vmscan_lru_isolate tracepoint
Subject: mm, vmscan: extract shrink_page_list reclaim counters into a struct
Subject: mm, vmscan: enhance mm_vmscan_lru_shrink_inactive tracepoint
Subject: mm, vmscan: add mm_vmscan_inactive_list_is_low tracepoint
Subject: trace-vmscan-postprocess: sync with tracepoints updates
Subject: nfs: no PG_private waiters remain, remove waker
Subject: mm: un-export wake_up_page functions
Subject: mm: fix filemap.c kernel-doc warnings
Subject: mm/mmzone.c: swap likely to unlikely as code logic is different for next_zones_zonelist()
Subject: mm, compaction: add vmstats for kcompactd work
Subject: mm: page_alloc: skip over regions of invalid pfns where possible
Subject: mm,compaction: serialize waitqueue_active() checks
Subject: mm/bootmem.c: cosmetic improvement of code readability
Subject: mm: fix some typos in mm/zsmalloc.c
Subject: mm/memblock.c: trivial code refine in memblock_is_region_memory()
Subject: mm/memblock.c: check return value of memblock_reserve() in memblock_virt_alloc_internal()
Subject: mm/sparse: use page_private() to get page->private value
Subject: mm/memory_hotplug: set magic number to page->freelist instead of page->lru.next
Subject: powerpc: do not make the entire heap executable
Subject: mm/swap: fix kernel message in swap_info_get()
Subject: mm/swap: add cluster lock
Subject: mm/swap: split swap cache into 64MB trunks
Subject: mm/swap: skip readahead for unreferenced swap slots
Subject: mm/swap: allocate swap slots in batches
Subject: mm/swap: free swap slots in batch
Subject: mm/swap: add cache for swap slots allocation
Subject: mm/swap: enable swap slots cache usage
Subject: mm/swap: skip readahead only when swap slot cache is enabled
Subject: mm, thp: add new defer+madvise defrag option
Subject: mm/backing-dev.c: use rb_entry()
Subject: mm, vmscan: do not count freed pages as PGDEACTIVATE
Subject: mm, vmscan: cleanup lru size claculations
Subject: mm, vmscan: consider eligible zones in get_scan_count
Subject: Revert "mm: bail out in shrink_inactive_list()"
Subject: mm, page_alloc: do not report all nodes in show_mem
Subject: mm, page_alloc: warn_alloc print nodemask
Subject: arch, mm: remove arch specific show_mem
Subject: lib/show_mem.c: teach show_mem to work with the given nodemask
Subject: mm: consolidate GFP_NOFAIL checks in the allocator slowpath
Subject: mm, oom: do not enforce OOM killer for __GFP_NOFAIL automatically
Subject: mm: help __GFP_NOFAIL allocations which do not trigger OOM killer
Subject: mm, page_alloc: warn_alloc nodemask is NULL when cpusets are disabled
Subject: mm: drop zap_details::ignore_dirty
Subject: mm: drop zap_details::check_swap_entries
Subject: mm: drop unused argument of zap_page_range()
Subject: oom-reaper: use madvise_dontneed() logic to decide if unmap the VMA
Subject: mm/memblock.c: remove unnecessary log and clean up
Subject: zram: remove obsolete sysfs attrs
Subject: mm: fix <linux/pagemap.h> stray kernel-doc notation
Subject: mm/z3fold.c: limit first_num to the actual range of possible buddy indexes

