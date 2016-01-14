From: akpm@linux-foundation.org
Subject: [folded-merged]
 include-define-__phys_to_pfn-as-phys_pfn-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:19:17 -0800
Message-ID: <56981ee5.js5COXFHTSq3smPL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbcANWTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:19:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gang.chen.5i5j@gmail.com, xili_gchen_5257@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include-define-__phys_to_pfn-as-phys_pfn-fix
has been removed from the -mm tree.  Its filename was
     include-define-__phys_to_pfn-as-phys_pfn-fix.patch

This patch was dropped because it was folded into include-define-__phys_to_pfn-as-phys_pfn.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-define-__phys_to_pfn-as-phys_pfn-fix

use macro arg name `x'

Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Chen Gang <xili_gchen_5257@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pfn.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pfn.h~include-define-__phys_to_pfn-as-phys_pfn-fix include/linux/pfn.h
--- a/include/linux/pfn.h~include-define-__phys_to_pfn-as-phys_pfn-fix
+++ a/include/linux/pfn.h
@@ -9,6 +9,6 @@
 #define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
 #define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
 #define PFN_PHYS(x)	((phys_addr_t)(x) << PAGE_SHIFT)
-#define PHYS_PFN(y)	((unsigned long)((y) >> PAGE_SHIFT))
+#define PHYS_PFN(x)	((unsigned long)((x) >> PAGE_SHIFT))
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
include-define-__phys_to_pfn-as-phys_pfn.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
mm-vmalloc-remove-vm_vpages-fix.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

