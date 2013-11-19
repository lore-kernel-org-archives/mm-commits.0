From: akpm@linux-foundation.org
Subject: +
 mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch added
 to -mm tree
Date: Mon, 18 Nov 2013 16:09:29 -0800
Message-ID: <528aac39.O+WNhPtOONnIIA3A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3KSAJa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 19:09:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, dhillf@gmail.com, dave.hansen@linux.intel.com, aarcange@redhat.com, akpm@linux-foundation.org

Subject: + mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,dave.hansen@linux.intel.com,dhillf@gmail.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 16:09:29 -0800


The patch titled
     Subject: mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix
has been added to the -mm tree.  Its filename is
     mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch

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
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
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

