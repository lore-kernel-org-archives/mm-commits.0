From: akpm@linux-foundation.org
Subject: - power_supply_ledssysfsc-should-include-power_supplyh.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:50:05 -0800
Message-ID: <200711262150.lAQLo5Zh024825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756187AbXKZV6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     patch] power_supply_{leds,sysfs}.c should #include "power_supply.h"
has been removed from the -mm tree.  Its filename was
     power_supply_ledssysfsc-should-include-power_supplyh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: patch] power_supply_{leds,sysfs}.c should #include "power_supply.h"
From: Adrian Bunk <bunk@kernel.org>

Every file should include the headers containing the prototypes for its global
functions.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/power_supply_leds.c  |    2 ++
 drivers/power/power_supply_sysfs.c |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/power/power_supply_leds.c~power_supply_ledssysfsc-should-include-power_supplyh drivers/power/power_supply_leds.c
--- a/drivers/power/power_supply_leds.c~power_supply_ledssysfsc-should-include-power_supplyh
+++ a/drivers/power/power_supply_leds.c
@@ -12,6 +12,8 @@
 
 #include <linux/power_supply.h>
 
+#include "power_supply.h"
+
 /* Battery specific LEDs triggers. */
 
 static void power_supply_update_bat_leds(struct power_supply *psy)
diff -puN drivers/power/power_supply_sysfs.c~power_supply_ledssysfsc-should-include-power_supplyh drivers/power/power_supply_sysfs.c
--- a/drivers/power/power_supply_sysfs.c~power_supply_ledssysfsc-should-include-power_supplyh
+++ a/drivers/power/power_supply_sysfs.c
@@ -14,6 +14,8 @@
 #include <linux/ctype.h>
 #include <linux/power_supply.h>
 
+#include "power_supply.h"
+
 /*
  * This is because the name "current" breaks the device attr macro.
  * The "current" word resolves to "(get_current())" so instead of
_

Patches currently in -mm which might be from bunk@kernel.org are

m68k-export-atari_keyb_init.patch
git-acpi.patch
git-avr32.patch
git-cifs.patch
git-dvb.patch
remove-saa7134-oss.patch
git-gfs2-nmw.patch
git-libata-all.patch
git-mtd.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
remove-additional-pci_scan_child_bus-prototype.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
git-x86.patch
git-xtensa.patch
xtensa-kernel-setupc-remove-dead-code.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
