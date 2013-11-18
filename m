From: akpm@linux-foundation.org
Subject: +
 mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes.patch added to -mm tree
Date: Mon, 18 Nov 2013 13:26:05 -0800
Message-ID: <528a85ed.tkN7e9j1zYDQyHg6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3KRV0G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 16:26:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dave.hansen@linux.intel.com, akpm@linux-foundation.org

Subject: + mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,dave.hansen@linux.intel.com
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 13:26:05 -0800


The patch titled
     Subject: mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes.patch

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
Subject: mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes

ERROR: code indent should use tabs where possible
#116: FILE: mm/migrate.c:452:
+ ^I^Icopy_huge_page(newpage, page);$

WARNING: please, no space before tabs
#116: FILE: mm/migrate.c:452:
+ ^I^Icopy_huge_page(newpage, page);$

WARNING: please, no spaces at the start of a line
#116: FILE: mm/migrate.c:452:
+ ^I^Icopy_huge_page(newpage, page);$

ERROR: space required before the open parenthesis '('
#117: FILE: mm/migrate.c:453:
+	else if(PageTransHuge(page))

total: 2 errors, 2 warnings, 55 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/migrate.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes mm/migrate.c
--- a/mm/migrate.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes
+++ a/mm/migrate.c
@@ -449,8 +449,8 @@ void migrate_page_copy(struct page *newp
 	int cpupid;
 
 	if (PageHuge(page))
- 		copy_huge_page(newpage, page);
-	else if(PageTransHuge(page))
+		copy_huge_page(newpage, page);
+	else if (PageTransHuge(page))
 		copy_high_order_page(newpage, page, HPAGE_PMD_ORDER);
 	else
 		copy_highpage(newpage, page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-checkpatch-fixes.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

