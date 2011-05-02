From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 02 May 2011 12:18:22 -0700
Message-ID: <201105021912.p42JCPKn006686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805Ab1EBTM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 May 2011 15:12:56 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p42JCQ0r016406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 2 May 2011 12:12:26 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-i801.c    |    3 ---
 drivers/i2c/busses/i2c-parport.c |    9 ---------
 include/linux/pci_ids.h          |    3 ---
 3 files changed, 15 deletions(-)

diff -puN drivers/i2c/busses/i2c-i801.c~linux-next-git-rejects drivers/i2c/busses/i2c-i801.c
--- a/drivers/i2c/busses/i2c-i801.c~linux-next-git-rejects
+++ a/drivers/i2c/busses/i2c-i801.c
@@ -142,10 +142,7 @@
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF0	0x1d70
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF1	0x1d71
 #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF2	0x1d72
-<<<<<<< HEAD
-=======
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
->>>>>>> FETCH_HEAD
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
 #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
 
diff -puN drivers/i2c/busses/i2c-parport.c~linux-next-git-rejects drivers/i2c/busses/i2c-parport.c
--- a/drivers/i2c/busses/i2c-parport.c~linux-next-git-rejects
+++ a/drivers/i2c/busses/i2c-parport.c
@@ -2,11 +2,6 @@
  * i2c-parport.c I2C bus over parallel port                                 *
  * ------------------------------------------------------------------------ *
    Copyright (C) 2003-2011 Jean Delvare <khali@linux-fr.org>
-<<<<<<< HEAD
-   
-=======
-
->>>>>>> FETCH_HEAD
    Based on older i2c-philips-par.c driver
    Copyright (C) 1995-2000 Simon G. Vogl
    With some changes from:
@@ -238,11 +233,7 @@ static void i2c_parport_attach(struct pa
 	mutex_lock(&adapter_list_lock);
 	list_add_tail(&adapter->node, &adapter_list);
 	mutex_unlock(&adapter_list_lock);
-<<<<<<< HEAD
-        return;
-=======
 	return;
->>>>>>> FETCH_HEAD
 
 ERROR1:
 	parport_release(adapter->pdev);
diff -puN include/linux/pci_ids.h~linux-next-git-rejects include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~linux-next-git-rejects
+++ a/include/linux/pci_ids.h
@@ -2479,12 +2479,9 @@
 #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
-<<<<<<< HEAD
-=======
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN	0x1e40
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX	0x1e5f
->>>>>>> FETCH_HEAD
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
 #define PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN	0x2310
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
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
mm-uninline-large-generic-tlbh-functions.patch
mm-thp-optimize-memcg-charge-in-khugepaged-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-fix.patch
mm-convert-mm-cpu_vm_cpumask-into-cpumask_var_t-checkpatch-fixes.patch
writeback-sync-expired-inodes-first-in-background-writeback-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
printk-allocate-kernel-log-buffer-earlier-v2-checkpatch-fixes.patch
printk-allocate-kernel-log-buffer-earlier-v2-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
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

