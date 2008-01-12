From: akpm@linux-foundation.org
Subject: + usb-make-usb_storage_onetouch-available-with-pm.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:36:37 -0800
Message-ID: <200801120136.m0C1ab0x008072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42009 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756952AbYALBhZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:37:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, gregkh@suse.de, just.for.lkml@googlemail.com, mdharm-usb@one-eyed-alien.net, n.sillik@temple.edu, stern@rowland.harvard.edu


The patch titled
     usb: make USB_STORAGE_ONETOUCH available with PM
has been added to the -mm tree.  Its filename is
     usb-make-usb_storage_onetouch-available-with-pm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: make USB_STORAGE_ONETOUCH available with PM
From: Adrian Bunk <bunk@kernel.org>

As Torsten Kaiser pointed out, it seems the dependency of
USB_STORAGE_ONETOUCH on !PM should have been removed in commit
7931e1c6f8007d5fef8a0bb2dc71bd97315eeae9.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Nick Sillik <n.sillik@temple.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/storage/Kconfig~usb-make-usb_storage_onetouch-available-with-pm drivers/usb/storage/Kconfig
--- a/drivers/usb/storage/Kconfig~usb-make-usb_storage_onetouch-available-with-pm
+++ a/drivers/usb/storage/Kconfig
@@ -123,7 +123,7 @@ config USB_STORAGE_ALAUDA
 
 config USB_STORAGE_ONETOUCH
 	bool "Support OneTouch Button on Maxtor Hard Drives (EXPERIMENTAL)"
-	depends on USB_STORAGE && INPUT_EVDEV && EXPERIMENTAL && !PM
+	depends on USB_STORAGE && INPUT_EVDEV && EXPERIMENTAL
 	help
 	  Say Y here to include additional code to support the Maxtor OneTouch
 	  USB hard drive's onetouch button.
_

Patches currently in -mm which might be from bunk@kernel.org are

scsi-qla2xxx-qla_osc-section-fix.patch
oss-msnd-fix-array-overflows.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-infiniband.patch
git-kbuild.patch
git-mtd.patch
git-net.patch
git-netdev-all.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
if-0-pci_cleanup_aer_correct_error_status.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
scsi-aic94xx-cleanups.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
git-x86.patch
git-cryptodev.patch
git-xtensa.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
m68knommu-remove-duplicate-exports.patch
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
xen-fiddle_vdso-must-be-__init.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
drivers-video-pm3fbc-section-fix.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
