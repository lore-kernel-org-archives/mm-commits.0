From: akpm@linux-foundation.org
Subject: [merged] drivers-tty-serial-pch_uartc-needs-slabh.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:38 -0700
Message-ID: <201105252031.p4PKV14I015032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753346Ab1EYUoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/tty/serial/pch_uart.c needs slab.h
has been removed from the -mm tree.  Its filename was
     drivers-tty-serial-pch_uartc-needs-slabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/tty/serial/pch_uart.c needs slab.h
From: Andrew Morton <akpm@linux-foundation.org>

alpha allmodconfig:

drivers/tty/serial/pch_uart.c: In function 'dma_handle_tx':
drivers/tty/serial/pch_uart.c:873: error: implicit declaration of function 'kzalloc'
drivers/tty/serial/pch_uart.c:873: warning: assignment makes pointer from integer without a cast
drivers/tty/serial/pch_uart.c: In function 'pch_uart_init_port':
drivers/tty/serial/pch_uart.c:1403: warning: assignment makes pointer from integer without a cast

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/pch_uart.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/tty/serial/pch_uart.c~drivers-tty-serial-pch_uartc-needs-slabh drivers/tty/serial/pch_uart.c
--- a/drivers/tty/serial/pch_uart.c~drivers-tty-serial-pch_uartc-needs-slabh
+++ a/drivers/tty/serial/pch_uart.c
@@ -15,6 +15,7 @@
  *Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
  */
 #include <linux/serial_reg.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/serial_core.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-m68k-merge-mmu-and-non-mmu-bitopsh.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
mtd-convert-to-seq_file-interface.patch
rfcomm-corec-avoid-dangling-pointer-check-session-exists-checkpatch-fixes.patch
drivers-bcma-host_pcic-needs-slabh.patch
slab-use-numa_no_node.patch
mm.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock-fix-fix-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch-fix.patch
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

