From: akpm@linux-foundation.org
Subject: +
 dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch added to -mm tree
Date: Wed, 27 Nov 2013 15:04:52 -0800
Message-ID: <52967a94.SoBgOMyhfLuoqUoS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab3K0XEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Nov 2013 18:04:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shuah.kh@samsung.com, joro@8bytes.org, dan.carpenter@oracle.com, alexander.h.duyck@intel.com, akpm@linux-foundation.org

Subject: + dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch added to -mm tree
To: akpm@linux-foundation.org,alexander.h.duyck@intel.com,dan.carpenter@oracle.com,joro@8bytes.org,shuah.kh@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 27 Nov 2013 15:04:52 -0800


The patch titled
     Subject: dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix
has been added to the -mm tree.  Its filename is
     dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch

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
Subject: dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix

Per Shuah: "dev_warn() on line 740 should use dev not entry->dev"

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/dma-debug.c~dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix
+++ a/lib/dma-debug.c
@@ -737,7 +737,7 @@ static int device_dma_allocations(struct
 	local_irq_restore(flags);
 
 	if (map_err_cnt)
-		dev_warn(entry->dev,
+		dev_warn(dev,
 			"DMA-API: device driver failed to check map errors: "
 			"[count] = %d\n", map_err_cnt);
 	return count;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
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
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

