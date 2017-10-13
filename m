From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 13 Oct 2017 15:57:16 -0700
Message-ID: <20171013155716.f9447fbae2e59f2e69e74eba@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdJMW5S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 18:57:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

18 fixes, based on 997301a860fca1a05ab8e383a8039b65f8abeb1e:

Subject: mm/migrate: fix indexing bug (off by one) and avoid out of bound access
Subject: lib/Kconfig.debug: kernel hacking menu: runtime testing: keep tests together
Subject: mm/madvise.c: add description for MADV_WIPEONFORK and MADV_KEEPONFORK
Subject: include/linux/of.h: provide of_n_{addr,size}_cells wrappers for !CONFIG_OF
Subject: mm/mempolicy: fix NUMA_INTERLEAVE_HIT counter
Subject: mm: remove unnecessary WARN_ONCE in page_vma_mapped_walk().
Subject: mm: only display online cpus of the numa node
Subject: userfaultfd: selftest: exercise -EEXIST only in background transfer
Subject: scripts/kallsyms.c: ignore symbol type 'n'
Subject: mm/cma.c: take __GFP_NOWARN into account in cma_alloc()
Subject: Revert "vmalloc: back off when the current task is killed"
Subject: tty: fall back to N_NULL if switching to N_TTY fails during hangup
Subject: linux/kernel.h: add/correct kernel-doc notation
Subject: fs/mpage.c: fix mpage_writepage() for pages with buffers
Subject: fs/binfmt_misc.c: node could be NULL when evicting inode
Subject: kmemleak: clear stale pointers from task stacks
Subject: mm: page_vma_mapped: ensure pmd is loaded with READ_ONCE outside of lock
Subject: mm, swap: use page-cluster as max window of VMA based swap readahead



