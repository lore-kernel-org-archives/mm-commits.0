From: akpm@linux-foundation.org
Subject: [merged] ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch removed from -mm tree
Date: Mon, 01 Mar 2010 11:46:35 -0800
Message-ID: <201003011946.o21JkZ4d028687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318Ab0CATq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 14:46:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, fenghua.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     arch/ia64/uv/kernel/setup.c: wrong attribute of HUB chip written in uv_setup()
has been removed from the -mm tree.  Its filename was
     ia64-wrong-attribute-of-hub-chip-written-in-uv_setup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/ia64/uv/kernel/setup.c: wrong attribute of HUB chip written in uv_setup()
From: Roel Kluin <roel.kluin@gmail.com>

n_val should be assigned to n_val attribute of HUB chip.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/uv/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/uv/kernel/setup.c~ia64-wrong-attribute-of-hub-chip-written-in-uv_setup arch/ia64/uv/kernel/setup.c
--- a/arch/ia64/uv/kernel/setup.c~ia64-wrong-attribute-of-hub-chip-written-in-uv_setup
+++ a/arch/ia64/uv/kernel/setup.c
@@ -104,7 +104,7 @@ void __init uv_setup(char **cmdline_p)
 		uv_cpu_hub_info(cpu)->lowmem_remap_top =
 			lowmem_redir_base + lowmem_redir_size;
 		uv_cpu_hub_info(cpu)->m_val = m_val;
-		uv_cpu_hub_info(cpu)->n_val = m_val;
+		uv_cpu_hub_info(cpu)->n_val = n_val;
 		uv_cpu_hub_info(cpu)->pnode_mask = (1 << n_val) -1;
 		uv_cpu_hub_info(cpu)->gpa_mask = (1 << (m_val + n_val)) - 1;
 		uv_cpu_hub_info(cpu)->gnode_upper = gnode_upper;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
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
alpha-ptr_err-overwrites-einval-in-syscall-osf_mount.patch
cryptocop-fix-assertion-in-create_output_descriptors.patch
cris-v32-typo-in-crisv32_arbiter_unwatch.patch
asiliantfb-fix-test-of-unsigned-in-asiliant_calc_dclk2.patch
w1-fix-test-in-ds2482_wait_1wire_idle.patch

