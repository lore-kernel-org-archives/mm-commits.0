From: akpm@linux-foundation.org
Subject: [merged] drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch removed from -mm tree
Date: Fri, 27 May 2011 12:56:44 -0700
Message-ID: <201105271954.p4RJsnw5017369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932150Ab1E0TzP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:55:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, agust@denx.de, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/mb862xx/mb862xxfbdrv.c needs uaccess.h
has been removed from the -mm tree.  Its filename was
     drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/mb862xx/mb862xxfbdrv.c needs uaccess.h
From: Andrew Morton <akpm@linux-foundation.org>

alpha allmodconfig:

drivers/video/mb862xx/mb862xxfbdrv.c: In function 'mb862xxfb_ioctl':
drivers/video/mb862xx/mb862xxfbdrv.c:323: error: implicit declaration of function 'copy_to_user'
drivers/video/mb862xx/mb862xxfbdrv.c:327: error: implicit declaration of function 'copy_from_user'

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/mb862xxfbdrv.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/mb862xx/mb862xxfbdrv.c~drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh drivers/video/mb862xx/mb862xxfbdrv.c
--- a/drivers/video/mb862xx/mb862xxfbdrv.c~drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh
+++ a/drivers/video/mb862xx/mb862xxfbdrv.c
@@ -16,6 +16,7 @@
 
 #include <linux/fb.h>
 #include <linux/delay.h>
+#include <linux/uaccess.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
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
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

