From: akpm@linux-foundation.org
Subject: [obsolete] hid-examplec-is-borked.patch removed from -mm tree
Date: Wed, 20 Apr 2011 15:17:13 -0700
Message-ID: <201104202217.p3KMHDPE030389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753473Ab1DTWRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 18:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     hid-example.c is borked
has been removed from the -mm tree.  Its filename was
     hid-examplec-is-borked.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid-example.c is borked
From: Andrew Morton <akpm@linux-foundation.org>

samples/hidraw/hid-example.c:29:23: error: sys/ioctl.h: No such file or directory
samples/hidraw/hid-example.c:30:23: error: sys/types.h: No such file or directory
samples/hidraw/hid-example.c:31:22: error: sys/stat.h: No such file or directory
samples/hidraw/hid-example.c:32:19: error: fcntl.h: No such file or directory
samples/hidraw/hid-example.c:33:20: error: unistd.h: No such file or directory
samples/hidraw/hid-example.c:36:19: error: stdio.h: No such file or directory
samples/hidraw/hid-example.c:37:20: error: string.h: No such file or directory
samples/hidraw/hid-example.c:38:20: error: stdlib.h: No such file or directory
samples/hidraw/hid-example.c:39:19: error: errno.h: No such file or directory
samples/hidraw/hid-example.c: In function 'main':
samples/hidraw/hid-example.c:53: error: implicit declaration of function 'open'
samples/hidraw/hid-example.c:56: error: implicit declaration of function 'perror'
samples/hidraw/hid-example.c:65: error: implicit declaration of function 'ioctl'
samples/hidraw/hid-example.c:69: error: implicit declaration of function 'printf'
samples/hidraw/hid-example.c:69: warning: incompatible implicit declaration of built-in function 'printf'
samples/hidraw/hid-example.c:80: error: implicit declaration of function 'puts'
samples/hidraw/hid-example.c:136: error: implicit declaration of function 'write'
samples/hidraw/hid-example.c:138: error: 'errno' undeclared (first use in this function)
samples/hidraw/hid-example.c:138: error: (Each undeclared identifier is reported only once
samples/hidraw/hid-example.c:138: error: for each function it appears in.)
samples/hidraw/hid-example.c:145: error: implicit declaration of function 'read'
samples/hidraw/hid-example.c:154: error: implicit declaration of function 'close'
make[1]: *** [samples/hidraw/hid-example.o] Error 1
make: *** [samples/hidraw/hid-example.o] Error 2
**FAILED**

Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/hidraw/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN samples/hidraw/Makefile~hid-examplec-is-borked samples/hidraw/Makefile
--- a/samples/hidraw/Makefile~hid-examplec-is-borked
+++ a/samples/hidraw/Makefile
@@ -2,7 +2,7 @@
 obj- := dummy.o
 
 # List of programs to build
-hostprogs-y := hid-example
+hostprogs-y := 
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
vfs-avoid-large-kmallocs-for-the-fdtable.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drivers-scsi-osstc-fix-warning.patch
drbd-fix-warning.patch
drivers-usb-misc-usbtestc-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
mm-mmu_gather-rework-fix.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value.patch
percpu_counter-change-return-value-and-add-comments-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

