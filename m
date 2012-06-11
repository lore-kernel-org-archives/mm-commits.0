From: akpm@linux-foundation.org
Subject: + mm-memoryc-fix-kernel-doc-warnings.patch added to -mm tree
Date: Mon, 11 Jun 2012 16:01:17 -0700
Message-ID: <20120611230117.44E5AA026F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:38226 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2FKXBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 19:01:18 -0400
Received: by qcsp5 with SMTP id p5so137386qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 16:01:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@xenotime.net


The patch titled
     Subject: mm/memory.c: fix kernel-doc warnings
has been added to the -mm tree.  Its filename is
     mm-memoryc-fix-kernel-doc-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1376,7 +1376,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 /**
  * zap_page_range - remove user pages in a given range
  * @vma: vm_area_struct holding the applicable pages
- * @address: starting address of pages to zap
+ * @start: starting address of pages to zap
  * @size: number of bytes to zap
  * @details: details of nonlinear truncation or shared cache invalidation
  *
_
Subject: Subject: mm/memory.c: fix kernel-doc warnings

Patches currently in -mm which might be from rdunlap@xenotime.net are

linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm-memoryc-fix-kernel-doc-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

