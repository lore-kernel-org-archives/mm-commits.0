From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 10 Nov 2016 10:45:54 -0800
Message-ID: <20161110104554.8bad8eeb993efb2d1149b801@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754491AbcKJSp4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Nov 2016 13:45:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

15 fixes, based on 27bcd37e0240bbe33f0efe244b5aad52104115b3:

Subject: mm: remove extra newline from allocation stall warning
Subject: mm, frontswap: make sure allocated frontswap map is assigned
Subject: shmem: fix pageflags after swapping DMA32 object
Subject: scripts/bloat-o-meter: fix SIGPIPE
Subject: mm/cma.c: check the max limit for cma allocation
Subject: swapfile: fix memory corruption via malformed swapfile
Subject: mm: hwpoison: fix thp split handling in memory_failure()
Subject: Revert "console: don't prefer first registered if DT specifies stdout-path"
Subject: ocfs2: fix not enough credit panic
Subject: mm/hugetlb: fix huge page reservation leak in private mapping error paths
Subject: mm/filemap: don't allow partially uptodate page for pipes
Subject: coredump: fix unfreezable coredumping task
Subject: memcg: prevent memcg caches to be both OFF_SLAB & OBJFREELIST_SLAB
Subject: mm: kmemleak: scan .data.ro_after_init
Subject: lib/stackdepot: export save/fetch stack for drivers



