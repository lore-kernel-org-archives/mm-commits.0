From: akpm@linux-foundation.org
Subject: + mm-make-optimistic-check-for-swapin-readahead-fix-3.patch added to -mm tree
Date: Fri, 27 May 2016 13:03:48 -0700
Message-ID: <5748a824.s/B+uLRUo6cXyp7A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbcE0UDt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 16:03:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: remove duplication of included header
has been added to the -mm tree.  Its filename is
     mm-make-optimistic-check-for-swapin-readahead-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-optimistic-check-for-swapin-readahead-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-optimistic-check-for-swapin-readahead-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm, thp: remove duplication of included header

swapops.h included for a second time in the commit:
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=639040960a340f6f987065fc52e149f4ea25ce25

This patch removes the duplication.

Link: http://lkml.kernel.org/r/1464335964-6510-2-git-send-email-ebru.akagunduz@gmail.com
Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix-3 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-make-optimistic-check-for-swapin-readahead-fix-3
+++ a/mm/huge_memory.c
@@ -30,7 +30,6 @@
 #include <linux/hashtable.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/page_idle.h>
-#include <linux/swapops.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-make-optimistic-check-for-swapin-readahead.patch
mm-make-optimistic-check-for-swapin-readahead-fix-3.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-vmstat-calculate-particular-vm-event.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged.patch
mm-thp-fix-possible-circular-locking-dependency-caused-by-sum_vm_event.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem.patch

