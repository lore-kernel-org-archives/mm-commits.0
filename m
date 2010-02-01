From: akpm@linux-foundation.org
Subject: [merged] cx23885-wrong-command-printed-in-cmd_to_str.patch removed from -mm tree
Date: Mon, 01 Feb 2010 10:38:55 -0800
Message-ID: <201002011838.o11IctQf004881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755575Ab0BASjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 13:39:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mchehab@infradead.org, stoth@kernellabs.com, mm-commits@vger.kernel.org


The patch titled
     cx23885: wrong command printed in cmd_to_str()
has been removed from the -mm tree.  Its filename was
     cx23885-wrong-command-printed-in-cmd_to_str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cx23885: wrong command printed in cmd_to_str()
From: Roel Kluin <roel.kluin@gmail.com>

The wrong command was printed for case CX2341X_ENC_SET_DNR_FILTER_MODE,
and a typo in case CX2341X_ENC_SET_PCR_ID.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-By: Steven Toth <stoth@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx23885/cx23885-417.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/cx23885/cx23885-417.c~cx23885-wrong-command-printed-in-cmd_to_str drivers/media/video/cx23885/cx23885-417.c
--- a/drivers/media/video/cx23885/cx23885-417.c~cx23885-wrong-command-printed-in-cmd_to_str
+++ a/drivers/media/video/cx23885/cx23885-417.c
@@ -681,7 +681,7 @@ static char *cmd_to_str(int cmd)
 	case CX2341X_ENC_SET_VIDEO_ID:
 		return  "SET_VIDEO_ID";
 	case CX2341X_ENC_SET_PCR_ID:
-		return  "SET_PCR_PID";
+		return  "SET_PCR_ID";
 	case CX2341X_ENC_SET_FRAME_RATE:
 		return  "SET_FRAME_RATE";
 	case CX2341X_ENC_SET_FRAME_SIZE:
@@ -693,7 +693,7 @@ static char *cmd_to_str(int cmd)
 	case CX2341X_ENC_SET_ASPECT_RATIO:
 		return  "SET_ASPECT_RATIO";
 	case CX2341X_ENC_SET_DNR_FILTER_MODE:
-		return  "SET_DNR_FILTER_PROPS";
+		return  "SET_DNR_FILTER_MODE";
 	case CX2341X_ENC_SET_DNR_FILTER_PROPS:
 		return  "SET_DNR_FILTER_PROPS";
 	case CX2341X_ENC_SET_CORING_LEVELS:
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
acpi-fix-confusion-in-acpi_evaluate_string-in-comment.patch
asus-acpi-remove-duplicate-comparison-of-asus_model-strings.patch
thinkpad-acpi-wrong-thermal-attribute_group-removed-in-thermal_exit.patch
gemini-wrong-registers-used-to-set-reg_level-in-gpio_set_irq_type.patch
dma-cases-ipu_pix_fmt_bgra32-bgr32-and-abgr32-are-the-same-in-ipu_ch_param_set_size.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-gpu-drm-drm_crtc_helperc-fix-setting-of-fb_changed-in-drm_crtc_helper_set_config.patch
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

