From: akpm@linux-foundation.org
Subject: - git-input-make-xpad_play_effect-static.patch removed from -mm tree
Date: Sat, 16 Jun 2007 08:31:06 -0700
Message-ID: <200706161531.l5GFV6Pr014674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49021 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536AbXFPPbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 16 Jun 2007 11:31:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     git-input: make xpad_play_effect() static
has been removed from the -mm tree.  Its filename was
     git-input-make-xpad_play_effect-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: git-input: make xpad_play_effect() static
From: Adrian Bunk <bunk@stusta.de>

Make the needlessly global xpad_play_effect() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/joystick/xpad.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/input/joystick/xpad.c~git-input-make-xpad_play_effect-static drivers/input/joystick/xpad.c
--- a/drivers/input/joystick/xpad.c~git-input-make-xpad_play_effect-static
+++ a/drivers/input/joystick/xpad.c
@@ -376,7 +376,8 @@ exit:
 		   __FUNCTION__, retval);
 }
 
-int xpad_play_effect(struct input_dev *dev, void *data, struct ff_effect *effect)
+static int xpad_play_effect(struct input_dev *dev, void *data,
+			    struct ff_effect *effect)
 {
 	struct usb_xpad *xpad = input_get_drvdata(dev);
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
git-dvb.patch
git-input.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
handle-kernelcore=-generic-fix.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
swsusp-remove-code-duplication-between-diskc-and-userc-fix.patch
more-scheduled-oss-driver-removal.patch
remove-sonypi_camera_command.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
kernel-sched_fairc-make-code-static.patch
fs-proc-basec-make-a-struct-static.patch
mm-implement-swap-prefetching-make-mm-swap_prefetchcremove_from_swapped_list.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks-fix.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
