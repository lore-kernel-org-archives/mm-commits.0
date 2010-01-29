From: akpm@linux-foundation.org
Subject: [merged] serqt_usb2-two-branches-the-same-in-qt_set_termios.patch removed from -mm tree
Date: Fri, 29 Jan 2010 12:17:05 -0800
Message-ID: <201001292017.o0TKH5iO003282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754192Ab0A2UXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jan 2010 15:23:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, gregkh@suse.de, oliver@neukum.org, wfp5p@virginia.edu, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/serqt_usb2/serqt_usb2.c: two branches the same in qt_set_termios()
has been removed from the -mm tree.  Its filename was
     serqt_usb2-two-branches-the-same-in-qt_set_termios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/serqt_usb2/serqt_usb2.c: two branches the same in qt_set_termios()
From: Roel Kluin <roel.kluin@gmail.com>

Regardless of the condition, the branches executed the same code

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/serqt_usb2/serqt_usb2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/serqt_usb2/serqt_usb2.c~serqt_usb2-two-branches-the-same-in-qt_set_termios drivers/staging/serqt_usb2/serqt_usb2.c
--- a/drivers/staging/serqt_usb2/serqt_usb2.c~serqt_usb2-two-branches-the-same-in-qt_set_termios
+++ a/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -1277,7 +1277,7 @@ static void qt_set_termios(struct tty_st
 	if (cflag & CSTOPB)
 		new_LCR |= SERIAL_TWO_STOPB;
 	else
-		new_LCR |= SERIAL_TWO_STOPB;
+		new_LCR |= SERIAL_ONE_STOPB;
 
 	dbg("%s - 4\n", __func__);
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-gpu-drm-drm_crtc_helperc-fix-setting-of-fb_changed-in-drm_crtc_helper_set_config.patch
cx23885-wrong-command-printed-in-cmd_to_str.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
hisax-timeout-off-by-one-in-waitrecmsg.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
dc395x-decrease-iteration-for-tag_number-of-max_command-in-start_scsi.patch
mpt2sas-fix-confusion-in-_scsih_sas_device_status_change_event.patch
lpfc-two-branches-the-same-in-lpfc_decode_firmware_rev.patch
paride-fix-off-by-one-test.patch
musb-test-always-evaluates-to-false.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

