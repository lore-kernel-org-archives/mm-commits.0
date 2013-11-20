From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-swapc-reorganize-put_compound_page-fix.patch
 removed from -mm tree
Date: Wed, 20 Nov 2013 13:24:22 -0800
Message-ID: <528d2886.L8U1IClvQTeKCHUd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab3KTVYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 16:24:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org

Subject: [to-be-updated] mm-swapc-reorganize-put_compound_page-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 13:24:22 -0800


The patch titled
     Subject: mm-swapc-reorganize-put_compound_page-fix
has been removed from the -mm tree.  Its filename was
     mm-swapc-reorganize-put_compound_page-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swapc-reorganize-put_compound_page-fix

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap.c~mm-swapc-reorganize-put_compound_page-fix mm/swap.c
--- a/mm/swap.c~mm-swapc-reorganize-put_compound_page-fix
+++ a/mm/swap.c
@@ -84,7 +84,7 @@ static void put_compound_page(struct pag
 {
 	struct page *page_head;
 
-	if (likely(PageTail(page))) {
+	if (likely(!PageTail(page))) {
 		if (put_page_testzero(page)) {
 			if (PageHead(page))
 				__put_compound_page(page);
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
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
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

