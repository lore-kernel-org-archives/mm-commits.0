From: akpm@linux-foundation.org
Subject: [merged] musb-test-always-evaluates-to-false.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:46:17 -0800
Message-ID: <201002182046.o1IKkHtB002872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0BRUrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:47:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, dbrownell@users.sourceforge.net, felipe.balbi@nokia.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     musb: test always evaluates to false
has been removed from the -mm tree.  Its filename was
     musb-test-always-evaluates-to-false.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: musb: test always evaluates to false
From: Roel Kluin <roel.kluin@gmail.com>

The removed part always evaluates to false.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/musb/musb_gadget.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/usb/musb/musb_gadget.c~musb-test-always-evaluates-to-false drivers/usb/musb/musb_gadget.c
--- a/drivers/usb/musb/musb_gadget.c~musb-test-always-evaluates-to-false
+++ a/drivers/usb/musb/musb_gadget.c
@@ -1710,8 +1710,7 @@ int usb_gadget_register_driver(struct us
 		return -EINVAL;
 
 	/* driver must be initialized to support peripheral mode */
-	if (!musb || !(musb->board_mode == MUSB_OTG
-				|| musb->board_mode != MUSB_OTG)) {
+	if (!musb) {
 		DBG(1, "%s, no dev??\n", __func__);
 		return -ENODEV;
 	}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-positive-error-return-into-negative.patch
scsi-bfa-correct-onstack-wait_queue_head-declaration.patch
paride-fix-off-by-one-test.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

