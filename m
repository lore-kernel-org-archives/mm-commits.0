From: akpm@osdl.org
Subject: - debug-add-sysrq_always_enabled-boot-option-cleanup.patch removed from -mm tree
Date: Tue, 12 Dec 2006 23:15:35 -0800
Message-ID: <200612130715.kBD7FZJ6031150@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59395 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932601AbWLMHSv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 02:18:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     make sysrq_always_enabled_setup() static
has been removed from the -mm tree.  Its filename was
     debug-add-sysrq_always_enabled-boot-option-cleanup.patch

This patch was dropped because it was folded into debug-add-sysrq_always_enabled-boot-option.patch

------------------------------------------------------
Subject: make sysrq_always_enabled_setup() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sysrq.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/sysrq.c~debug-add-sysrq_always_enabled-boot-option-cleanup drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~debug-add-sysrq_always_enabled-boot-option-cleanup
+++ a/drivers/char/sysrq.c
@@ -59,7 +59,7 @@ static inline int sysrq_on_mask(int mask
 						(__sysrq_enabled & mask);
 }
 
-int __init sysrq_always_enabled_setup(char *str)
+static int __init sysrq_always_enabled_setup(char *str)
 {
 	sysrq_always_enabled = 1;
 	printk(KERN_INFO "debug: sysrq always enabled.\n");
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
debug-add-sysrq_always_enabled-boot-option.patch
debug-add-sysrq_always_enabled-boot-option-cleanup.patch
one-more-export_unused_symbol-removal.patch
remove-the-broken-blk_dev_swim_iop-driver.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-ext2_get_blocks-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

