From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Sat, 28 Mar 2020 19:14:56 -0700
Message-ID: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbgC2CO5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 28 Mar 2020 22:14:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org

5 fixes, based on 83fd69c93340177dcd66fd26ce6441fb581c1dbf:


    Naohiro Aota <naohiro.aota@wdc.com>:
      mm/swapfile.c: move inode_lock out of claim_swapfile

    David Hildenbrand <david@redhat.com>:
      drivers/base/memory.c: indicate all memory blocks as removable

    Mina Almasry <almasrymina@google.com>:
      hugetlb_cgroup: fix illegal access to memory

    Roman Gushchin <guro@fb.com>:
      mm: fork: fix kernel_stack memcg stats for various stack implementations

    "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>:
      mm/sparse: fix kernel crash with pfn_section_valid check

 drivers/base/memory.c      |   23 +++--------------------
 include/linux/memcontrol.h |   12 ++++++++++++
 kernel/fork.c              |    4 ++--
 mm/hugetlb_cgroup.c        |    3 +--
 mm/memcontrol.c            |   38 ++++++++++++++++++++++++++++++++++++++
 mm/sparse.c                |    6 ++++++
 mm/swapfile.c              |   41 ++++++++++++++++++++---------------------
 7 files changed, 82 insertions(+), 45 deletions(-)
