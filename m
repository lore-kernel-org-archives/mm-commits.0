From: akpm@linux-foundation.org
Subject: [obsolete] gpio-hack.patch removed from -mm tree
Date: Tue, 21 Jan 2014 16:03:35 -0800
Message-ID: <52df0ad7.MBi0MNUWL8dD7DKa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaAVADg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 19:03:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] gpio-hack.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 16:03:35 -0800


The patch titled
     Subject: a
has been removed from the -mm tree.  Its filename was
     gpio-hack.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/gpio/Kconfig~gpio-hack drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-hack
+++ a/drivers/gpio/Kconfig
@@ -733,6 +733,7 @@ config GPIO_MAX7301
 config GPIO_MCP23S08
 	tristate "Microchip MCP23xxx I/O expander"
 	depends on (SPI_MASTER && !I2C) || I2C && OF_GPIO
+	depends on OF_GPIO
 	help
 	  SPI/I2C driver for Microchip MCP23S08/MCP23S17/MCP23008/MCP23017
 	  I/O expanders.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
posix_acl-uninlining.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-add-overcommit_kbytes-sysctl-variable.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
sched-add-tracepoints-related-to-numa-task-migration.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
mm.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

