From: akpm@linux-foundation.org
Subject: [merged] mm-memoryc-fix-kernel-doc-warnings.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:34 -0700
Message-ID: <20120621192534.599B5A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:32812 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760108Ab2FUTZf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:35 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so96393ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     mm-memoryc-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: mm/memory.c: fix kernel-doc warnings

Fix kernel-doc warnings in mm/memory.c:

Warning(mm/memory.c:1377): No description found for parameter 'start'
Warning(mm/memory.c:1377): Excess function parameter 'address' description in 'zap_page_range'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-memoryc-fix-kernel-doc-warnings mm/memory.c
--- a/mm/memory.c~mm-memoryc-fix-kernel-doc-warnings
+++ a/mm/memory.c
@@ -1375,7 +1375,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 /**
  * zap_page_range - remove user pages in a given range
  * @vma: vm_area_struct holding the applicable pages
- * @address: starting address of pages to zap
+ * @start: starting address of pages to zap
  * @size: number of bytes to zap
  * @details: details of nonlinear truncation or shared cache invalidation
  *
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
lib-vsprintfc-remind-people-to-update-documentation-printk-formatstxt-when-adding-printk-formats.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

