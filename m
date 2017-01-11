From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Tue, 10 Jan 2017 16:57:02 -0800
Message-ID: <20170110165702.965909957562c70ec05c01c8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759840AbdAKA5E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 19:57:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

27 fixes, based on bd5d7428f5e50cc10b98cf0abc13ccac391e1e33:

The three patches

Subject: mm: rename __alloc_page_frag to page_frag_alloc and __free_page_frag to page_frag_free
Subject: mm: rename __page_frag functions to __page_frag_cache, drop order from drain
Subject: mm: add documentation for page fragment APIs

aren't actually fixes.  They're simple function renamings which are
nice-to-have in mainline as ongoing net development depends on them.


Subject: MAINTAINERS: remove duplicate bug filling description
Subject: dax: fix deadlock with DAX 4k holes
Subject: mm/thp/pagecache/collapse: free the pte page table on collapse for thp page cache.
Subject: mm: add follow_pte_pmd()
Subject: dax: wrprotect pmd_t in dax_mapping_entry_mkclean
Subject: mm, slab: make sure that KMALLOC_MAX_SIZE will fit into MAX_ORDER
Subject: bpf: do not use KMALLOC_SHIFT_MAX
Subject: ocfs2: fix crash caused by stale lvb with fsdlm plugin
Subject: mm: fix devm_memremap_pages crash, use mem_hotplug_{begin, done}
Subject: mm: fix remote numa hits statistics
Subject: mm: get rid of __GFP_OTHER_NODE
Subject: lib/Kconfig.debug: fix frv build failure
Subject: ipc/sem.c: fix incorrect sem_lock pairing
Subject: mm: pmd dirty emulation in page fault handler
Subject: signal: protect SIGNAL_UNKILLABLE from unintentional clearing.
Subject: mailmap: add codeaurora.org names for nameless email commits
Subject: mm: don't dereference struct page fields of invalid pages
Subject: mm, memcg: fix the active list aging for lowmem requests when memcg is enabled
Subject: mm: rename __alloc_page_frag to page_frag_alloc and __free_page_frag to page_frag_free
Subject: mm: rename __page_frag functions to __page_frag_cache, drop order from drain
Subject: mm: add documentation for page fragment APIs
Subject: mm: support anonymous stable page
Subject: zram: revalidate disk under init_lock
Subject: zram: support BDI_CAP_STABLE_WRITES
Subject: mm/slab.c: fix SLAB freelist randomization duplicate entries
Subject: mm/hugetlb.c: fix reservation race when freeing surplus pages
Subject: timerfd: export defines to userspace

