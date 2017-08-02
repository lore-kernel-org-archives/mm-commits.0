From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Wed, 2 Aug 2017 13:31:22 -0700
Message-ID: <20170802133122.fdc9aa0060696776b0d1aa72@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45866 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752342AbdHBUbX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:31:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

16 fixes, based on 4d3f5d04d69e9479a3df88ceb0e2cd8188a49366:

Subject: mm/hugetlb.c: __get_user_pages ignores certain follow_hugetlb_page errors
Subject: pid: kill pidhash_size in pidhash_init()
Subject: mm, mprotect: flush TLB if potentially racing with a parallel reclaim leaving stale TLB entries
Subject: userfaultfd: non-cooperative: notify about unmap of destination during mremap
Subject: kasan: avoid -Wmaybe-uninitialized warning
Subject: kthread: fix documentation build warning
Subject: zram: do not free pool->size_class
Subject: fortify: use WARN instead of BUG for now
Subject: mm/page_io.c: fix oops during block io poll in swapin path
Subject: mm: take memory hotplug lock within numa_zonelist_order_handler()
Subject: userfaultfd_zeropage: return -ENOSPC in case mm has gone
Subject: cpuset: fix a deadlock due to incomplete patching of cpusets_enabled()
Subject: ipc: add missing container_of()s for randstruct
Subject: userfaultfd: non-cooperative: flush event_wqh at release time
Subject: mm: allow page_cache_get_speculative in interrupt context
Subject: ocfs2: don't clear SGID when inheriting ACLs



