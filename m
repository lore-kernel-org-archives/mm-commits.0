From: akpm@linux-foundation.org
Subject: + mm-cma-release-trigger-checkpatch-fixes.patch added to -mm tree
Date: Wed, 18 Feb 2015 14:27:38 -0800
Message-ID: <54e511da.SzPCb7XDiNp2rpNf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbbBRW1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 17:27:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-release-trigger-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-cma-release-trigger-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-release-trigger-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-release-trigger-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-cma-release-trigger-checkpatch-fixes

ERROR: code indent should use tabs where possible
#76: FILE: mm/cma_debug.c:88:
+        int pages = val;$

WARNING: please, no spaces at the start of a line
#76: FILE: mm/cma_debug.c:88:
+        int pages = val;$

ERROR: code indent should use tabs where possible
#79: FILE: mm/cma_debug.c:91:
+        return cma_free_mem(cma, pages);$

WARNING: please, no spaces at the start of a line
#79: FILE: mm/cma_debug.c:91:
+        return cma_free_mem(cma, pages);$

total: 2 errors, 2 warnings, 69 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-cma-release-trigger.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/cma_debug.c~mm-cma-release-trigger-checkpatch-fixes mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-release-trigger-checkpatch-fixes
+++ a/mm/cma_debug.c
@@ -85,10 +85,10 @@ static int cma_free_mem(struct cma *cma,
 
 static int cma_free_write(void *data, u64 val)
 {
-        int pages = val;
+	int pages = val;
 	struct cma *cma = data;
 
-        return cma_free_mem(cma, pages);
+	return cma_free_mem(cma, pages);
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(cma_free_fops, NULL, cma_free_write, "%llu\n");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
linux-next.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

