From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-export-a-function-to-get-vm-committed-memory-fix.patch removed from -mm tree
Date: Thu, 15 Nov 2012 14:33:32 -0800
Message-ID: <20121115223333.222512001BD@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48099 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2KOWdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 17:33:35 -0500
Received: by mail-fa0-f74.google.com with SMTP id w1so141544fad.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 14:33:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kys@microsoft.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-export-a-function-to-get-vm-committed-memory-fix
has been removed from the -mm tree.  Its filename was
     mm-export-a-function-to-get-vm-committed-memory-fix.patch

This patch was dropped because it was folded into mm-export-a-function-to-get-vm-committed-memory.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-export-a-function-to-get-vm-committed-memory-fix

coding-style tweak

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c  |    1 -
 mm/nommu.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN mm/mmap.c~mm-export-a-function-to-get-vm-committed-memory-fix mm/mmap.c
--- a/mm/mmap.c~mm-export-a-function-to-get-vm-committed-memory-fix
+++ a/mm/mmap.c
@@ -97,7 +97,6 @@ struct percpu_counter vm_committed_as __
  * Several metrics drive this policy engine including the guest reported
  * memory commitment.
  */
-
 unsigned long vm_memory_committed(void)
 {
 	return percpu_counter_read_positive(&vm_committed_as);
diff -puN mm/nommu.c~mm-export-a-function-to-get-vm-committed-memory-fix mm/nommu.c
--- a/mm/nommu.c~mm-export-a-function-to-get-vm-committed-memory-fix
+++ a/mm/nommu.c
@@ -74,7 +74,6 @@ atomic_long_t mmap_pages_allocated;
  * Several metrics drive this policy engine including the guest reported
  * memory commitment.
  */
-
 unsigned long vm_memory_committed(void)
 {
 	return percpu_counter_read_positive(&vm_committed_as);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

swapfile-fix-name-leak-in-swapoff-fix.patch
mm-export-a-function-to-get-vm-committed-memory.patch
linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-fix-up-zone-present-pages.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
maintainers-add-joe-to-checkpatch-maintainers.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
thp-copy_huge_pmd-copy-huge-zero-page-v6-fix.patch

