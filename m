From: akpm@linux-foundation.org
Subject: + mm-show_mem-remove-show_mem_filter_page_count-fix.patch added
 to -mm tree
Date: Mon, 16 Dec 2013 15:37:54 -0800
Message-ID: <52af8ed2.OYPWqbN2TWM7TiWt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab3LPXhz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 18:37:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, rientjes@google.com, mgorman@suse.de, linux@arm.linux.org.uk, jejb@parisc-linux.org, akpm@linux-foundation.org

Subject: + mm-show_mem-remove-show_mem_filter_page_count-fix.patch added to -mm tree
To: akpm@linux-foundation.org,jejb@parisc-linux.org,linux@arm.linux.org.uk,mgorman@suse.de,rientjes@google.com,tony.luck@intel.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 15:37:54 -0800


The patch titled
     Subject: mm-show_mem-remove-show_mem_filter_page_count-fix
has been added to the -mm tree.  Its filename is
     mm-show_mem-remove-show_mem_filter_page_count-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-show_mem-remove-show_mem_filter_page_count-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-show_mem-remove-show_mem_filter_page_count-fix.patch

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
Subject: mm-show_mem-remove-show_mem_filter_page_count-fix

fix parisc

Cc: David Rientjes <rientjes@google.com>
Cc: James Bottomley <jejb@parisc-linux.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/mm/init.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN arch/parisc/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count-fix arch/parisc/mm/init.c
--- a/arch/parisc/mm/init.c~mm-show_mem-remove-show_mem_filter_page_count-fix
+++ a/arch/parisc/mm/init.c
@@ -663,9 +663,6 @@ void show_mem(unsigned int filter)
 
 			total += zone->present_pages;
 			reserved = zone->present_pages - zone->managed_pages;
-
-			if (is_highmem_idx(zoneid))
-				highmem += zone->present_pages;
 		}
 		pgdat_resize_unlock(pgdat, &flags);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

