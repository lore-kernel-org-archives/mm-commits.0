From: akpm@linux-foundation.org
Subject: + mm-memoryc-fix-kernel-doc-notation.patch added to -mm tree
Date: Fri, 27 May 2011 14:38:10 -0700
Message-ID: <201105272138.p4RLcAtY022796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756982Ab1E0ViN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 17:38:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     mm/memory.c: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     mm-memoryc-fix-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/memory.c: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix new kernel-doc warnings in mm/memory.c:

Warning(mm/memory.c:1327): No description found for parameter 'tlb'
Warning(mm/memory.c:1327): Excess function parameter 'tlbp' description in 'unmap_vmas'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-fix-kernel-doc-notation mm/memory.c
--- a/mm/memory.c~mm-memoryc-fix-kernel-doc-notation
+++ a/mm/memory.c
@@ -1296,7 +1296,7 @@ static unsigned long unmap_page_range(st
 
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
- * @tlbp: address of the caller's struct mmu_gather
+ * @tlb: address of the caller's struct mmu_gather
  * @vma: the starting vma
  * @start_addr: virtual address at which to start unmapping
  * @end_addr: virtual address at which to end unmapping
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
mm-memoryc-fix-kernel-doc-notation.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

