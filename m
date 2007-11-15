From: akpm@linux-foundation.org
Subject: - blk_dev_idecd-help-remove-outdated-note.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:12:42 -0800
Message-ID: <200711152112.lAFLCgIs015876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57918 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763270AbXKOVS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, bzolnier@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     BLK_DEV_IDECD help: remove outdated note
has been removed from the -mm tree.  Its filename was
     blk_dev_idecd-help-remove-outdated-note.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: BLK_DEV_IDECD help: remove outdated note
From: Adrian Bunk <bunk@kernel.org>

LILO version 16 was released on 26-02-1995 (sic), so telling people to not use
older versions no longer has any value.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/ide/Kconfig~blk_dev_idecd-help-remove-outdated-note drivers/ide/Kconfig
--- a/drivers/ide/Kconfig~blk_dev_idecd-help-remove-outdated-note
+++ a/drivers/ide/Kconfig
@@ -203,10 +203,6 @@ config BLK_DEV_IDECD
 	  CD-ROM drive, you can say N to all other CD-ROM options, but be sure
 	  to say Y or M to "ISO 9660 CD-ROM file system support".
 
-	  Note that older versions of LILO (LInux LOader) cannot properly deal
-	  with IDE/ATAPI CD-ROMs, so install LILO 16 or higher, available from
-	  <http://lilo.go.dyndns.org/>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called ide-cd.
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-avr32.patch
git-dvb.patch
remove-saa7134-oss.patch
git-gfs2-nmw.patch
git-libata-all.patch
git-mtd.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
always-export-pci_scan_single_device.patch
remove-additional-pci_scan_child_bus-prototype.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
git-x86.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
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
power_supply_ledssysfsc-should-include-power_supplyh.patch
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
