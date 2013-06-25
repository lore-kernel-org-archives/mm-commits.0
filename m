From: akpm@linux-foundation.org
Subject: + mm-memblockc-fix-wrong-comment-in-__next_free_mem_range.patch
 added to -mm tree
Date: Tue, 25 Jun 2013 16:54:29 -0700
Message-ID: <51ca2db5.fFi1V3TGhextFJXj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3FYXya (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 19:54:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com

Subject: + mm-memblockc-fix-wrong-comment-in-__next_free_mem_range.patch added to -mm tree
To: tangchen@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 16:54:29 -0700


The patch titled
     Subject: mm/memblock.c: fix wrong comment in __next_free_mem_range()
has been added to the -mm tree.  Its filename is
     mm-memblockc-fix-wrong-comment-in-__next_free_mem_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm/memblock.c: fix wrong comment in __next_free_mem_range()

Remove one redundant "nid" in the comment.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---

index c5fad93..a847bfe 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblockc-fix-wrong-comment-in-__next_free_mem_range mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-fix-wrong-comment-in-__next_free_mem_range
+++ a/mm/memblock.c
@@ -566,7 +566,7 @@ int __init_memblock memblock_reserve(phy
 /**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
- * @nid: nid: node selector, %MAX_NUMNODES for all nodes
+ * @nid: node selector, %MAX_NUMNODES for all nodes
  * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @out_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @out_nid: ptr to int for nid of the range, can be %NULL
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

linux-next.patch
mm-change-signature-of-free_reserved_area-to-fix-building-warnings.patch
mm-enhance-free_reserved_area-to-support-poisoning-memory-with-zero.patch
mm-arm64-kill-poison_init_mem.patch
mm-x86-use-free_reserved_area-to-simplify-code.patch
mm-tile-use-common-help-functions-to-free-reserved-pages.patch
mm-fix-some-trivial-typos-in-comments.patch
mm-use-managed_pages-to-calculate-default-zonelist-order.patch
mm-accurately-calculate-zone-managed_pages-for-highmem-zones.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-make-__free_pages_bootmem-only-available-at-boot-time.patch
mm-correctly-update-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages-fix.patch
mm-concentrate-modification-of-totalram_pages-into-the-mm-core.patch
mm-report-available-pages-as-memtotal-for-each-numa-node.patch
mm-hotplug-prepare-for-removing-num_physpages.patch
mm-sh-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-sparc-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-x86-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-ia64-prepare-for-killing-free_all_bootmem_node.patch
mm-sh-prepare-for-killing-free_all_bootmem_node.patch
page-migration-fix-wrong-comment-in-address_space_operationsmigratepage.patch
mm-memblockc-fix-wrong-comment-in-__next_free_mem_range.patch
aio-fix-wrong-comment-in-aio_complete.patch
mm-memory_hotplugc-fix-a-comment-typo-in-register_page_bootmem_info_node.patch

