From: akpm@linux-foundation.org
Subject: [folded-merged]
 pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch removed from -mm tree
Date: Tue, 08 Sep 2015 14:36:28 -0700
Message-ID: <55ef54dc.wHYwxe9jCBL16xuB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbbIHVg3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:36:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khlebnikov@yandex-team.ru, mwilliamson@undo-software.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix
has been removed from the -mm tree.  Its filename was
     pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch

This patch was dropped because it was folded into pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix

fix spello

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mark Williamson <mwilliamson@undo-software.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/pagemap.txt~pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix
+++ a/Documentation/vm/pagemap.txt
@@ -16,7 +16,7 @@ There are three components to pagemap:
     * Bits 0-4   swap type if swapped
     * Bits 5-54  swap offset if swapped
     * Bit  55    pte is soft-dirty (see Documentation/vm/soft-dirty.txt)
-    * Bit  56    page exlusively mapped
+    * Bit  56    page exclusively mapped
     * Bits 57-60 zero
     * Bit  61    page is file-page or shared-anon
     * Bit  62    page swapped
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

dax-revert-userfaultfd-change.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch

