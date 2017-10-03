From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Tue, 3 Oct 2017 16:14:03 -0700
Message-ID: <20171003161403.377e2a73e37005cf1f187f3c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXOE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org


A lot of stuff, sorry about that.  A week on a beach, then a bunch of
time catching up then more time letting it bake in -next.  Shan't do
that again!

51 fixes, based on d81fa669e3de7eb8a631d7d95dac5fbcb2bf9d4e:

Subject: alpha: fix build failures
Subject: kernel/params.c: align add_sysfs_param documentation with code
Subject: scripts/spelling.txt: add more spelling mistakes to spelling.txt
Subject: include/linux/mm.h: fix typo in VM_MPX definition
Subject: ksm: fix unlocked iteration over vmas in cmp_and_merge_page()
Subject: mm, hugetlb, soft_offline: save compound page order before page migration
Subject: sh: sh7722: remove nonexistent GPIO_PTQ7 to fix pinctrl registration
Subject: sh: sh7757: remove nonexistent GPIO_PT[JLNQ]7_RESV to fix pinctrl registration
Subject: sh: sh7264: remove nonexistent GPIO_PH[0-7] to fix pinctrl registration
Subject: sh: sh7269: remove nonexistent GPIO_PH[0-7] to fix pinctrl registration
Subject: z3fold: fix potential race in z3fold_reclaim_page
Subject: mm, oom_reaper: skip mm structs with mmu notifiers
Subject: mm, memcg: remove hotplug locking from try_charge
Subject: mm/memcg: avoid page count check for zone device
Subject: android: binder: drop lru lock in isolate callback
Subject: mm,compaction: serialize waitqueue_active() checks (for real)
Subject: z3fold: fix stale list handling
Subject: mm: meminit: mark init_reserved_page as __meminit
Subject: rapidio: remove global irq spinlocks from the subsystem
Subject: mm: fix RODATA_TEST failure "rodata_test: test data was not read only"
Subject: zram: fix null dereference of handle
Subject: m32r: define CPU_BIG_ENDIAN
Subject: mm: have filemap_check_and_advance_wb_err clear AS_EIO/AS_ENOSPC
Subject: mm: avoid marking swap cached page as lazyfree
Subject: mm: fix data corruption caused by lazyfree page
Subject: mm/device-public-memory: fix edge case in _vm_normal_page()
Subject: userfaultfd: non-cooperative: fix fork use after free
Subject: exec: load_script: kill the onstack interp[BINPRM_BUF_SIZE] array
Subject: exec: binfmt_misc: don't nullify Node->dentry in kill_node()
Subject: exec: binfmt_misc: shift filp_close(interp_file) from kill_node() to bm_evict_inode()
Subject: exec: binfmt_misc: remove the confusing e->interp_file != NULL checks
Subject: exec: binfmt_misc: fix race between load_misc_binary() and kill_node()
Subject: exec: binfmt_misc: kill the onstack iname[BINPRM_BUF_SIZE] array
Subject: lib/lz4: make arrays static const, reduces object code size
Subject: include/linux/bitfield.h: remove 32bit from FIELD_GET comment block
Subject: kernel/sysctl.c: remove duplicate UINT_MAX check on do_proc_douintvec_conv()
Subject: mm: memcontrol: use vmalloc fallback for large kmem memcg arrays
Subject: lib/idr.c: fix comment for idr_replace()
Subject: mm, memory_hotplug: add scheduling point to __add_pages
Subject: mm, page_alloc: add scheduling point to memmap_init_zone
Subject: memremap: add scheduling point to devm_memremap_pages
Subject: kernel/kcmp.c: drop branch leftover typo
Subject: mm/memory_hotplug: change pfn_to_section_nr/section_nr_to_pfn macro to inline function
Subject: mm/memory_hotplug: define find_{smallest|biggest}_section_pfn as unsigned long
Subject: kernel/params.c: fix the maximum length in param_get_string
Subject: kernel/params.c: fix an overflow in param_attr_show
Subject: kernel/params.c: improve STANDARD_PARAM_DEF readability
Subject: lib/ratelimit.c: use deferred printk() version
Subject: m32r: fix build failure
Subject: checkpatch: fix ignoring cover-letter logic
Subject: include/linux/fs.h: fix comment about struct address_space



