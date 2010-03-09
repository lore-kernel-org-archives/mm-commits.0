From: akpm@linux-foundation.org
Subject: [merged] cris-v32-typo-in-crisv32_arbiter_unwatch.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:19 -0800
Message-ID: <201003091905.o29J5J6H031115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755569Ab0CITGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:06:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris v32: typo in crisv32_arbiter_unwatch()?
has been removed from the -mm tree.  Its filename was
     cris-v32-typo-in-crisv32_arbiter_unwatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris v32: typo in crisv32_arbiter_unwatch()?
From: Roel Kluin <roel.kluin@gmail.com>

With id 1 the wrong bp was unwatched.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/mach-fs/arbiter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/cris/arch-v32/mach-fs/arbiter.c~cris-v32-typo-in-crisv32_arbiter_unwatch arch/cris/arch-v32/mach-fs/arbiter.c
--- a/arch/cris/arch-v32/mach-fs/arbiter.c~cris-v32-typo-in-crisv32_arbiter_unwatch
+++ a/arch/cris/arch-v32/mach-fs/arbiter.c
@@ -332,7 +332,7 @@ int crisv32_arbiter_unwatch(int id)
 	if (id == 0)
 		intr_mask.bp0 = regk_marb_no;
 	else if (id == 1)
-		intr_mask.bp2 = regk_marb_no;
+		intr_mask.bp1 = regk_marb_no;
 	else if (id == 2)
 		intr_mask.bp2 = regk_marb_no;
 	else if (id == 3)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

linux-next.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
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
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

