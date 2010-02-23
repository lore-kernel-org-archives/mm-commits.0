From: akpm@linux-foundation.org
Subject: [nacked] m68km68knommu-missing-asterisk.patch removed from -mm tree
Date: Mon, 22 Feb 2010 22:16:16 -0800
Message-ID: <201002230616.o1N6GGjd015096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab0BWGQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Feb 2010 01:16:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, geert@linux-m68k.org, gerg@snapgear.com, mm-commits@vger.kernel.org


The patch titled
     m68k,m68knommu: missing asterisk
has been removed from the -mm tree.  Its filename was
     m68km68knommu-missing-asterisk.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k,m68knommu: missing asterisk
From: Roel Kluin <roel.kluin@gmail.com>

An asterisk was missing.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/apollohw.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m68k/include/asm/apollohw.h~m68km68knommu-missing-asterisk arch/m68k/include/asm/apollohw.h
--- a/arch/m68k/include/asm/apollohw.h~m68km68knommu-missing-asterisk
+++ a/arch/m68k/include/asm/apollohw.h
@@ -94,7 +94,7 @@ extern u_long timer_physaddr;
 
 #define sio01 ((*(volatile struct SCN2681 *)(IO_BASE + sio01_physaddr)))
 #define sio23 ((*(volatile struct SCN2681 *)(IO_BASE + sio23_physaddr)))
-#define rtc (((volatile struct mc146818 *)(IO_BASE + rtc_physaddr)))
+#define rtc ((*(volatile struct mc146818 *)(IO_BASE + rtc_physaddr)))
 #define cpuctrl (*(volatile unsigned int *)(IO_BASE + cpuctrl_physaddr))
 #define pica (IO_BASE + pica_physaddr)
 #define picb (IO_BASE + picb_physaddr)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
dvb-usb-opera1-misplaced-parenthesis.patch
ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch
mtd-hot-spin-and-code-duplication-in-nand_bcm_umi_bch_read_oobecc.patch
mtd-change-positive-error-return-into-negative-in-mtd_do_writeoob.patch
score-fix-dereference-of-null-pointer-in-local_flush_tlb_page.patch
isdn-misplaced-parenthesis-in-pof_handle_data.patch
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
m68km68knommu-missing-asterisk.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

