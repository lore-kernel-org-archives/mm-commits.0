From: akpm@linux-foundation.org
Subject: + mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
 added to -mm tree
Date: Fri, 22 Nov 2013 14:59:39 -0800
Message-ID: <528fe1db.pjqX902hwc+q1QTk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab3KVW7k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:59:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wuzhy@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: + mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch added to -mm tree
To: akpm@linux-foundation.org,wuzhy@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:59:39 -0800


The patch titled
     Subject: mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix
has been added to the -mm tree.  Its filename is
     mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch

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
Subject: mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix

s/cache/pagecache/

Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix
+++ a/mm/memory-failure.c
@@ -611,7 +611,7 @@ static int me_pagecache_clean(struct pag
 }
 
 /*
- * Dirty cache page
+ * Dirty pagecache page
  * Issues: when the error hit a hole page the error is not properly
  * propagated.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
arch-um-kernel-sysrqc-rename-print_stack_trace.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

