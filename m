From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 12 May 2017 15:45:26 -0700
Message-ID: <20170512154526.3a70bb42b9c83e80d6465c89@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38554 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757852AbdELWp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2017 18:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

15 fixes, based on deac8429d62ca19c1571853e2a18f60e760ee04c:

Subject: hwpoison, memcg: forcibly uncharge LRU pages
Subject: time: delete current_fs_time()
Subject: mm, vmstat: Remove spurious WARN() during zoneinfo print
Subject: gcov: support GCC 7.1
Subject: mm/khugepaged: add missed tracepoint for collapse_huge_page_swapin
Subject: mm, vmalloc: fix vmalloc users tracking properly
Subject: Tigran has moved
Subject: dax: prevent invalidation of mapped DAX entries
Subject: mm: fix data corruption due to stale mmap reads
Subject: ext4: return to starting transaction in ext4_dax_huge_fault()
Subject: dax: fix data corruption when fault races with write
Subject: dax: fix PMD data corruption when fault races with write
Subject: mm, thp: copying user pages must schedule on collapse
Subject: mm: vmscan: scan until it finds eligible pages
Subject: mm, docs: update memory.stat description with workingset* entries



