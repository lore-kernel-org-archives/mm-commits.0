From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 14 Dec 2017 15:32:09 -0800
Message-ID: <20171214153209.33a8e5634eebd40d492d9fc5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54176 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754292AbdLNXcL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Dec 2017 18:32:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

17 fixes, based on 7c5cac1bc7170bfc726a69eb64947c55658d16ad:

Subject: include/linux/idr.h: add #include <linux/bug.h>
Subject: lib/rbtree,drm/mm: add rbtree_replace_node_cached()
Subject: mm/kmemleak.c: make cond_resched() rate-limiting more efficient
Subject: string.h: workaround for increased stack usage
Subject: autofs: fix careless error in recent commit
Subject: exec: avoid gcc-8 warning for get_task_comm
Subject: Documentation/vm/zswap.txt: update with same-value filled page feature
Subject: scripts/faddr2line: fix CROSS_COMPILE unset error
Subject: mm/memory.c: mark wp_huge_pmd() inline to prevent build failure
Subject: mm/page_alloc.c: avoid excessive IRQ disabled times in free_unref_page_list()
Subject: mm/slab.c: do not hash pointers when debugging slab
Subject: kcov: fix comparison callback signature
Subject: tools/slabinfo-gnuplot: force to use bash shell
Subject: mm/frame_vector.c: release a semaphore in 'get_vaddr_frames()'
Subject: kernel: make groups_sort calling a responsibility group_info allocators
Subject: mm, oom_reaper: fix memory corruption
Subject: arch: define weak abort()

