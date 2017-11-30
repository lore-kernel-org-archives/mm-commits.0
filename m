From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 29 Nov 2017 16:09:42 -0800
Message-ID: <20171129160942.f55e02be07a703052ea4b70f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752838AbdK3AJo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

28 fixes, based on 43570f0383d6d5879ae585e6c3cf027ba321546f:

Subject: mm, memory_hotplug: do not back off draining pcp free pages from kworker context
Subject: mm, oom_reaper: gather each vma to prevent leaking TLB entry
Subject: mm/cma: fix alloc_contig_range ret code/potential leak
Subject: mm: fix device-dax pud write-faults triggered by get_user_pages()
Subject: mm: switch to 'define pmd_write' instead of __HAVE_ARCH_PMD_WRITE
Subject: mm: replace pud_write with pud_access_permitted in fault + gup paths
Subject: mm: replace pmd_write with pmd_access_permitted in fault + gup paths
Subject: mm: replace pte_write with pte_access_permitted in fault + gup paths
Subject: scripts/faddr2line: extend usage on generic arch
Subject: mm, hugetlbfs: introduce ->split() to vm_operations_struct
Subject: device-dax: implement ->split() to catch invalid munmap attempts
Subject: mm: introduce get_user_pages_longterm
Subject: mm: fail get_vaddr_frames() for filesystem-dax mappings
Subject: v4l2: disable filesystem-dax mapping support
Subject: IB/core: disable memory registration of filesystem-dax vmas
Subject: exec: avoid RLIMIT_STACK races with prlimit()
Subject: mm/madvise.c: fix madvise() infinite loop under special circumstances
Subject: Revert "mm/page-writeback.c: print a warning if the vm dirtiness settings are illogical"
Subject: fs/mbcache.c: make count_objects() more robust
Subject: scripts/bloat-o-meter: don't fail with division by 0
Subject: kmemleak: add scheduling point to kmemleak_scan()
Subject: mm: migrate: fix an incorrect call of prep_transhuge_page()
Subject: mm, memcg: fix mem_cgroup_swapout() for THPs
Subject: fs/fat/inode.c: fix sb_rdonly() change
Subject: autofs: revert "autofs: take more care to not update last_used on path walk"
Subject: autofs: revert "autofs: fix AT_NO_AUTOMOUNT not being honored"
Subject: mm/hugetlb: fix NULL-pointer dereference on 5-level paging machine
Subject: fs/hugetlbfs/inode.c: change put_page/unlock_page order in hugetlbfs_fallocate()



