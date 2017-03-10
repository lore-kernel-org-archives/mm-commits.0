From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 9 Mar 2017 16:15:48 -0800
Message-ID: <20170309161548.736d68ec389718d7eac62d86@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51112 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbdCJAPu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:15:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

26 fixes, based on ea6200e84182989a3cce9687cf79a23ac44ec4db:

Subject: userfaultfd: shmem: __do_fault requires VM_FAULT_NOPAGE
Subject: scripts/spelling.txt: add "disble(d)" pattern and fix typo instances
Subject: scripts/spelling.txt: add "overide" pattern and fix typo instances
Subject: powerpc/mm: handle protnone ptes on fork
Subject: power/mm: update pte_write and pte_wrprotect to handle savedwrite
Subject: x86, mm: fix gup_pte_range() vs DAX mappings
Subject: x86, mm: unify exit paths in gup_pte_range()
Subject: userfaultfd: non-cooperative: rollback userfaultfd_exit
Subject: userfaultfd: non-cooperative: robustness check
Subject: userfaultfd: non-cooperative: release all ctx in dup_userfaultfd_complete
Subject: include/linux/fs.h: fix unsigned enum warning with gcc-4.2
Subject: mm/vmstats: add thp_split_pud event for clarity
Subject: drivers/md/bcache/util.h: remove duplicate inclusion of blkdev.h
Subject: mm/cgroup: avoid panic when init with low memory
Subject: userfaultfd: non-cooperative: fix fork fctx->new memleak
Subject: userfaultfd: non-cooperative: userfaultfd_remove revalidate vma in MADV_DONTNEED
Subject: userfaultfd: selftest: vm: allow to build in vm/ directory
Subject: mm/memblock.c: fix memblock_next_valid_pfn()
Subject: rmap: fix NULL-pointer dereference on THP munlocking
Subject: thp: fix another corner case of munlock() vs. THPs
Subject: mm: do not call mem_cgroup_free() from within mem_cgroup_alloc()
Subject: kasan: resched in quarantine_remove_cache()
Subject: kasan: fix races in quarantine_remove_cache()
Subject: sh: cayman: IDE support fix
Subject: fat: fix using uninitialized fields of fat_inode/fsinfo_inode
Subject: userfaultfd: remove wrong comment from userfaultfd_ctx_get()



