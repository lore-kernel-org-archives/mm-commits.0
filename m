From: akpm@linux-foundation.org
Subject: [merged] pxa-add-missing-underscores-in-define.patch removed from -mm tree
Date: Thu, 12 Nov 2009 12:13:32 -0800
Message-ID: <200911122013.nACKDW42017645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbZKLUNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 15:13:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, eric.miao@marvell.com, mingwei.wang@marvell.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxa: add missing underscores in define
has been removed from the -mm tree.  Its filename was
     pxa-add-missing-underscores-in-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxa: add missing underscores in define
From: Roel Kluin <roel.kluin@gmail.com>

Underscores were missing.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mingwei Wang <mingwei.wang@marvell.com>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/arm/mach-mmp/include/mach/mfp-pxa910.h~pxa-add-missing-underscores-in-define arch/arm/mach-mmp/include/mach/mfp-pxa910.h
--- a/arch/arm/mach-mmp/include/mach/mfp-pxa910.h~pxa-add-missing-underscores-in-define
+++ a/arch/arm/mach-mmp/include/mach/mfp-pxa910.h
@@ -160,7 +160,7 @@
 #define MMC1_WP_MMC1_WP		MFP_CFG_DRV(MMC1_WP, AF0, MEDIUM)
 
 /* PWM */
-#define GPIO27 PWM3 AF2		MFP_CFG(GPIO27, AF2)
+#define GPIO27_PWM3_AF2		MFP_CFG(GPIO27, AF2)
 #define GPIO51_PWM2_OUT		MFP_CFG(GPIO51, AF2)
 #define GPIO117_PWM1_OUT	MFP_CFG(GPIO117, AF2)
 #define GPIO118_PWM2_OUT	MFP_CFG(GPIO118, AF2)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
fujitsu-laptop-fix-tests-of-acpi_evaluate_integer-return.patch
omap-fix-unlikelyx-y.patch
omap-cs-should-be-positive-in-gpmc_cs_free.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
ibmmca-buffer-overflow.patch
scsi-eata-fix-buffer-overflow.patch
drivers-scsi-gdthc-fix-buffer-overflow.patch
drivers-scsi-u14-34fc-fix-uffer-overflow.patch
drivers-scsi-lpfc-lpfc_vportc-fix-read-buffer-overflow.patch
osst-fix-read-buffer-overflow.patch
gdth-unmap-ccb_phys-when-scsi_add_host-fails-in-gdth_eisa_probe_one.patch
zfcp-test-kmalloc-failure-in-scsi_get_vpd_page.patch
st-fix-test-of-value-range-in-st_set_options.patch
ncr5380-bit-mr_dma_mode-set-twice-in-ncr5380_transfer_dma.patch
scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer.patch
page-types-unsigned-cannot-be-less-than-0-in-add_page.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
gpio-fix-test-on-unsigned-in-lnw_irq_type.patch
fbdev-tv_paln-bit-set-twice-in-sisfb_detect_vb_connect.patch
hvc_console-fix-test-on-unsigned-in-hvc_console_print.patch
irq-fix-test-in-__exit-parport_mfc3_exit.patch

