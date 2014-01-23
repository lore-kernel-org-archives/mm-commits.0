From: akpm@linux-foundation.org
Subject: [folded-merged] mm-print-more-details-for-bad_page-fix.patch
 removed from -mm tree
Date: Thu, 23 Jan 2014 15:16:56 -0800
Message-ID: <52e1a2e8.2bGzdSpoiBI5s300%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaAWXQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dave.hansen@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-print-more-details-for-bad_page-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dave.hansen@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:16:56 -0800


The patch titled
     Subject: mm-print-more-details-for-bad_page-fix
has been removed from the -mm tree.  Its filename was
     mm-print-more-details-for-bad_page-fix.patch

This patch was dropped because it was folded into mm-print-more-details-for-bad_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-print-more-details-for-bad_page-fix

switch to pr_alert.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-print-more-details-for-bad_page-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-print-more-details-for-bad_page-fix
+++ a/mm/page_alloc.c
@@ -6527,9 +6527,9 @@ void dump_page_badflags(struct page *pag
 		page->mapping, page->index);
 	dump_page_flags(page->flags);
 	if (reason)
-		printk(KERN_ALERT "page dumped because: %s\n", reason);
+		pr_alert("page dumped because: %s\n", reason);
 	if (page->flags & badflags) {
-		printk(KERN_ALERT "bad because of flags:\n");
+		pr_alert("bad because of flags:\n");
 		dump_page_flags(page->flags & badflags);
 	}
 	mem_cgroup_print_bad_page(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-print-more-details-for-bad_page.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

