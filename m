From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 31 Mar 2017 15:11:27 -0700
Message-ID: <20170331151127.9dab3d7d127fc1adb9829f8c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933149AbdCaWL3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2017 18:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

11 fixes, based on d4562267b995fa3917717cc7773dad9c1f1ca658:

Subject: mm: migrate: fix remove_migration_pte() for ksm pages
Subject: mm: move mm_percpu_wq initialization earlier
Subject: mm: rmap: fix huge file mmap accounting in the memcg stats
Subject: mm: workingset: fix premature shadow node shrinking with cgroups
Subject: mm, hugetlb: use pte_present() instead of pmd_present() in follow_huge_pmd()
Subject: mm: fix section name for .data..ro_after_init
Subject: hugetlbfs: initialize shared policy as part of inode allocation
Subject: kasan: report only the first error by default
Subject: mm/hugetlb.c: don't call region_abort if region_chg fails
Subject: drivers/rapidio/devices/tsi721.c: make module parameter variable name unique
Subject: kasan: do not sanitize kexec purgatory



