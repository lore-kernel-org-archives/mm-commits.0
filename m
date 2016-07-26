From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Tue, 26 Jul 2016 15:16:42 -0700
Message-ID: <20160726151642.a1845e89b443e9d581aceba5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Jul_2016_15_16_42_-0700_oYaaLQ=+BZ.qG8V7"
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbcGZWQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:16:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

--Signature=_Tue__26_Jul_2016_15_16_42_-0700_oYaaLQ=+BZ.qG8V7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


- a few misc bits

- ocfs2

- most(?) of MM


126 patches, based on e65805251f2db69c9f67ed8062ab82526be5a374:

Subject: arm: get rid of superfluous __GFP_REPEAT
Subject: dax: some small updates to dax.txt documentation
Subject: dax: remote unused fault wrappers
Subject: dma-debug: track bucket lock state for static checkers
Subject: fbmon: remove unused function argument
Subject: CFLAGS: add -Wunused-but-set-parameter
Subject: kbuild: abort build on bad stack protector flag
Subject: scripts/bloat-o-meter: fix percent on <1% changes
Subject: m32r: add __ucmpdi2 to fix build failure
Subject: debugobjects.h: fix trivial kernel doc warning
Subject: ocfs2: fix a redundant re-initialization
Subject: ocfs2: improve recovery performance
Subject: ocfs2: cleanup unneeded goto in ocfs2_create_new_inode_locks
Subject: ocfs2/dlm: fix memory leak of dlm_debug_ctxt
Subject: ocfs2: cleanup implemented prototypes
Subject: ocfs2: remove obscure BUG_ON in dlmglue
Subject: ocfs2/cluster: clean up unnecessary assignment for 'ret'
Subject: fs/fs-writeback.c: add a new writeback list for sync
Subject: fs/fs-writeback.c: inode writeback list tracking tracepoints
Subject: mm: reorganize SLAB freelist randomization
Subject: mm: SLUB freelist randomization
Subject: slab: make GFP_SLAB_BUG_MASK information more human readable
Subject: slab: do not panic on invalid gfp_mask
Subject: mm: faster kmalloc_array(), kcalloc()
Subject: mm/slab: use list_move instead of list_del/list_add
Subject: mm/memcontrol.c: remove the useless parameter for mc_handle_swap_p=
te
Subject: mm/init: fix zone boundary creation
Subject: memory-hotplug: add move_pfn_range()
Subject: memory-hotplug: more general validation of zone during online
Subject: memory-hotplug: use zone_can_shift() for sysfs valid_zones attribu=
te
Subject: mm: zap ZONE_OOM_LOCKED
Subject: mm: oom: add memcg to oom_control
Subject: include/linux/mmdebug.h: add VM_WARN which maps to WARN()
Subject: powerpc/mm: check for irq disabled() only if DEBUG_VM is enabled
Subject: zram: rename zstrm find-release functions
Subject: zram: switch to crypto compress API
Subject: zram: use crypto api to check alg availability
Subject: zram: cosmetic: cleanup documentation
Subject: zram: delete custom lzo/lz4
Subject: zram: add more compression algorithms
Subject: zram: drop gfp_t from zcomp_strm_alloc()
Subject: mm: use put_page() to free page instead of putback_lru_page()
Subject: mm: migrate: support non-lru movable page migration
Subject: mm: balloon: use general non-lru movable page feature
Subject: zsmalloc: keep max_object in size_class
Subject: zsmalloc: use bit_spin_lock
Subject: zsmalloc: use accessor
Subject: zsmalloc: factor page chain functionality out
Subject: zsmalloc: introduce zspage structure
Subject: zsmalloc: separate free_zspage from putback_zspage
Subject: zsmalloc: use freeobj for index
Subject: zsmalloc: page migration support
Subject: zram: use __GFP_MOVABLE for memory allocation
Subject: zsmalloc: use OBJ_TAG_BIT for bit shifter
Subject: mm/compaction: split freepages without holding the zone lock
Subject: mm/page_owner: initialize page owner without holding the zone lock
Subject: mm/page_owner: copy last_migrate_reason in copy_page_owner()
Subject: mm/page_owner: introduce split_page_owner and replace manual handl=
ing
Subject: tools/vm/page_owner: increase temporary buffer size
Subject: mm/page_owner: use stackdepot to store stacktrace
Subject: mm/page_alloc: introduce post allocation processing on page alloca=
tor
Subject: mm/page_isolation: clean up confused code
Subject: mm: thp: check pmd_trans_unstable() after split_huge_pmd()
Subject: mm/hugetlb: simplify hugetlb unmap
Subject: mm: change the interface for __tlb_remove_page()
Subject: mm/mmu_gather: track page size with mmu gather and force flush if =
page size change
Subject: mm: remove pointless struct in struct page definition
Subject: mm: clean up non-standard page->_mapcount users
Subject: mm: memcontrol: cleanup kmem charge functions
Subject: mm: charge/uncharge kmemcg from generic page allocator paths
Subject: mm: memcontrol: teach uncharge_list to deal with kmem pages
Subject: arch: x86: charge page tables to kmemcg
Subject: pipe: account to kmemcg
Subject: af_unix: charge buffers to kmemcg
Subject: mm,oom: remove unused argument from oom_scan_process_thread().
Subject: mm, frontswap: convert frontswap_enabled to static key
Subject: mm: add NR_ZSMALLOC to vmstat
Subject: include/linux/memblock.h: Clean up code for several trivial details
Subject: mm, oom_reaper: make sure that mmput_async is called only when mem=
ory was reaped
Subject: mm, memcg: use consistent gfp flags during readahead
Subject: mm/memblock.c:memblock_add_range(): if nr_new is 0 just return
Subject: mm: make optimistic check for swapin readahead
Subject: mm: make swapin readahead to improve thp collapse rate
Subject: mm, thp: make swapin readahead under down_read of mmap_sem
Subject: mm, thp: fix locking inconsistency in collapse_huge_page
Subject: khugepaged: recheck pmd after mmap_sem re-acquired
Subject: thp, mlock: update unevictable-lru.txt
Subject: mm: do not pass mm_struct into handle_mm_fault
Subject: mm: introduce fault_env
Subject: mm: postpone page table allocation until we have page to map
Subject: rmap: support file thp
Subject: mm: introduce do_set_pmd()
Subject: thp, vmstats: add counters for huge file pages
Subject: thp: support file pages in zap_huge_pmd()
Subject: thp: handle file pages in split_huge_pmd()
Subject: thp: handle file COW faults
Subject: thp: skip file huge pmd on copy_huge_pmd()
Subject: thp: prepare change_huge_pmd() for file thp
Subject: thp: run vma_adjust_trans_huge() outside i_mmap_rwsem
Subject: thp: file pages support for split_huge_page()
Subject: thp, mlock: do not mlock PTE-mapped file huge pages
Subject: vmscan: split file huge pages before paging them out
Subject: page-flags: relax policy for PG_mappedtodisk and PG_reclaim
Subject: radix-tree: implement radix_tree_maybe_preload_order()
Subject: filemap: prepare find and delete operations for huge pages
Subject: truncate: handle file thp
Subject: mm, rmap: account shmem thp pages
Subject: shmem: prepare huge=3D mount option and sysfs knob
Subject: shmem: get_unmapped_area align huge page
Subject: shmem: add huge pages support
Subject: shmem, thp: respect MADV_{NO,}HUGEPAGE for file mappings
Subject: thp: extract khugepaged from mm/huge_memory.c
Subject: khugepaged: move up_read(mmap_sem) out of khugepaged_alloc_page()
Subject: shmem: make shmem_inode_info::lock irq-safe
Subject: khugepaged: add support of collapse for tmpfs/shmem pages
Subject: thp: introduce CONFIG_TRANSPARENT_HUGE_PAGECACHE
Subject: shmem: split huge pages beyond i_size under memory pressure
Subject: thp: update Documentation/{vm/transhuge,filesystems/proc}.txt
Subject: mm, thp: fix comment inconsistency for swapin readahead functions
Subject: mm, thp: convert from optimistic swapin collapsing to conservative
Subject: mm: fix build warnings in <linux/compaction.h>
Subject: mm: memcontrol: remove BUG_ON in uncharge_list
Subject: mm: memcontrol: fix documentation for compound parameter
Subject: cgroup: fix idr leak for the first cgroup root
Subject: cgroup: remove unnecessary 0 check from css_from_id()
Subject: thp: fix comments of __pmd_trans_huge_lock()


--Signature=_Tue__26_Jul_2016_15_16_42_-0700_oYaaLQ=+BZ.qG8V7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJXl+FPAAoJEJxZ78cCqAIHxeUP/iwaYellemTXg+rdlCy3r3EC
DkS0ASBw7mQb5483NFfjmrz1a76P39HT6siRZorPjDewy2wq2wfjq3BkpaPNscGv
4BCIg6MvMqftX4vgx9gk0mI63fc8PLTZQaKnc4r6upfoWxId7K5t5u7H81AHmLzg
PcXtPSO7YJw/bSUq6bFceIY9VEiPHepIeAi36aeP6eY68cmYa9RlBt8Ux/vlPeeR
ujulOvr3FrTOaaE/MTpV3v4KMS8tXEBJzcYHKOSFHvv6znkJLeWgDYjtzJ0Arc5n
r2h86aeP0TNVeMkPw+w4sYd/5HyoyZMiRpIFw9yPcSs5u+qENsyzOW4UHBlLVEx2
0WEHA9Ur322L7rgiwcyOLVfO+0bLs1+QyxC4SB4oWw2UPddRFfj/J5KTLroa2JOr
IpY7A+ZvCcPG2SIJT8VezBQFdrDkpXUSA31qbjgGxXWRFd2tg5eqOnUh9A1cNpJC
CvmfnvOXyeKBcl9nfKJ8aYUb13AE8iRb1mbZexqOX0sdwitWcYRXdISQvngZOIiD
G6jz/Pi3U39XnxbrBXEEPSJUenbgWobG8gHaP5SE3Lg6w8dYy6OGsarrNQu268TG
gvkRwCR8GFKUiT817H4YuOmy6b/GkBZduCcECPNUP22uV+/J1/bSbcEtISEetgyS
ItK7E4LcmVbbU/TkVUzO
=AP7q
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jul_2016_15_16_42_-0700_oYaaLQ=+BZ.qG8V7--
