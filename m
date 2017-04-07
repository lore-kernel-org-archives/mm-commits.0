From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Fri, 7 Apr 2017 16:04:30 -0700
Message-ID: <20170407160430.ce393cd10e603564d33b5497@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37194 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbdDGXEb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 19:04:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org

10 fixes, based on 81d4bab4ce87228c37ab14a885438544af5c9ce6:

Subject: mm: fix page_vma_mapped_walk() for ksm pages
Subject: userfaultfd: report actual registered features in fdinfo
Subject: mm/page_alloc.c: fix print order in show_free_areas()
Subject: vmlinux.lds: add missing VMLINUX_SYMBOL macros
Subject: ptrace: fix PTRACE_LISTEN race corrupting task->state
Subject: mm, thp: fix setting of defer+madvise thp defrag mode
Subject: dax: fix radix tree insertion race
Subject: mm, swap_cgroup: reschedule when neeed in swap_cgroup_swapoff()
Subject: mailmap: update Yakir Yang email address
Subject: mm: move pcp and lru-pcp draining into single wq

