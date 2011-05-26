From: akpm@linux-foundation.org
Subject: [merged] drivers-video-mb862xx-mb862xx-i2cc-needs-delayh.patch removed from -mm tree
Date: Thu, 26 May 2011 12:40:16 -0700
Message-ID: <201105261938.p4QJcVJL015308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754886Ab1EZTik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 15:38:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agust@denx.de, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/mb862xx/mb862xx-i2c.c needs delay.h
has been removed from the -mm tree.  Its filename was
     drivers-video-mb862xx-mb862xx-i2cc-needs-delayh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/mb862xx/mb862xx-i2c.c needs delay.h
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allmodconfig:

drivers/video/mb862xx/mb862xx-i2c.c: In function 'mb862xx_i2c_wait_event':
drivers/video/mb862xx/mb862xx-i2c.c:25: error: implicit declaration of function 'udelay'

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/mb862xx-i2c.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/mb862xx/mb862xx-i2c.c~drivers-video-mb862xx-mb862xx-i2cc-needs-delayh drivers/video/mb862xx/mb862xx-i2c.c
--- a/drivers/video/mb862xx/mb862xx-i2c.c~drivers-video-mb862xx-mb862xx-i2cc-needs-delayh
+++ a/drivers/video/mb862xx/mb862xx-i2c.c
@@ -12,6 +12,7 @@
 #include <linux/fb.h>
 #include <linux/i2c.h>
 #include <linux/io.h>
+#include <linux/delay.h>
 
 #include "mb862xxfb.h"
 #include "mb862xx_reg.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
ufs-truncated-values-handling-64-bit-metadata-fix.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-m68k-merge-mmu-and-non-mmu-bitopsh.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
mtd-convert-to-seq_file-interface.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix-checkpatch-fixes.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
add-the-pagefault-count-into-memcg-stats.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support-v3-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

