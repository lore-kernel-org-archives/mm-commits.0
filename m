From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 10 Aug 2017 15:23:17 -0700
Message-ID: <20170810152317.b59dfc6bdc1249ea9762de20@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbdHJWXS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:23:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

21 fixes, based on 26273939ace935dd7553b31d279eab30b40f7b9a:

Subject: mm: fix global NR_SLAB_.*CLAIMABLE counter reads
Subject: mm: ratelimit PFNs busy info message
Subject: userfaultfd: hugetlbfs: remove superfluous page unlock in VM_SHARED case
Subject: test_kmod: fix spelling mistake: "EMTPY" -> "EMPTY"
Subject: test_kmod: fix bug which allows negative values on two config options
Subject: test_kmod: fix the lock in register_test_dev_kmod()
Subject: test_kmod: fix small memory leak on filesystem tests
Subject: fault-inject: fix wrong should_fail() decision in task context
Subject: mm: migrate: prevent racy access to tlb_flush_pending
Subject: mm: migrate: fix barriers around tlb_flush_pending
Subject: Revert "mm: numa: defer TLB flush for THP migration as long as possible"
Subject: mm: refactor TLB gathering API
Subject: mm: make tlb_flush_pending global
Subject: mm: fix MADV_[FREE|DONTNEED] TLB flush miss problem
Subject: mm: fix KSM data corruption
Subject: MAINTAINERS: copy virtio on balloon_compaction.c
Subject: mm/balloon_compaction.c: don't zero ballooned pages
Subject: mm: fix list corruptions on shmem shrinklist
Subject: rmap: do not call mmu_notifier_invalidate_page() under ptl
Subject: zram: rework copy of compressor name in comp_algorithm_store()
Subject: userfaultfd: replace ENOSPC with ESRCH in case mm has gone during copy/zeropage

