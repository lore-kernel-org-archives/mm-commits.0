From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
 removed from -mm tree
Date: Thu, 21 Nov 2013 14:29:11 -0800
Message-ID: <528e8937.IbyykfPAJt6C/K3o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3KUW3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Nov 2013 17:29:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, dhillf@gmail.com, dave.hansen@linux.intel.com, aarcange@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,dave.hansen@linux.intel.com,dhillf@gmail.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 21 Nov 2013 14:29:11 -0800


The patch titled
     Subject: mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch

This patch was dropped because it was folded into mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix

fix coding-style and comment text, per Naoya Horiguchi

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/migrate.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix mm/migrate.c
--- a/mm/migrate.c~mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix
+++ a/mm/migrate.c
@@ -442,9 +442,9 @@ int migrate_huge_page_move_mapping(struc
 }
 
 /*
- * Gigantic pages are so large that the we do not guarantee
- * that page++ pointer arithmetic will work across the
- * entire page.  We need something more specialized.
+ * Gigantic pages are so large that we do not guarantee that page++ pointer
+ * arithmetic will work across the entire page.  We need something more
+ * specialized.
  */
 static void __copy_gigantic_page(struct page *dst, struct page *src,
 				int nr_pages)
@@ -483,7 +483,7 @@ static void copy_huge_page(struct page *
 		nr_pages = hpage_nr_pages(src);
 	}
 
-	for (i = 0; i < nr_pages; i++ ) {
+	for (i = 0; i < nr_pages; i++) {
 		cond_resched();
 		copy_highpage(dst + i, src + i);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

