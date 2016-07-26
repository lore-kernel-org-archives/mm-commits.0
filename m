From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-make-optimistic-check-for-swapin-readahead-fix-3.patch removed from -mm
 tree
Date: Tue, 26 Jul 2016 14:11:43 -0700
Message-ID: <5797d20f.nMPPK4Lk4ltQtPOP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333AbcGZVLo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:11:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: remove duplication of included header
has been removed from the -mm tree.  Its filename was
     mm-make-optimistic-check-for-swapin-readahead-fix-3.patch

This patch was dropped because it was folded into mm-make-optimistic-check-for-swapin-readahead.patch

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
mm-make-swapin-readahead-to-improve-thp-collapse-rate.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-ks.patch
mm-thp-fix-locking-inconsistency-in-collapse_huge_page.patch
mm-thp-fix-comment-inconsistency-for-swapin-readahead-functions.patch
mm-thp-convert-from-optimistic-swapin-collapsing-to-conservative.patch

