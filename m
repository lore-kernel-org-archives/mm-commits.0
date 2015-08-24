From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 24 Aug 2015 11:36:12 -0700
Message-ID: <55db641c.RT8AcI/UevfXgq8T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbbHXSgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 14:36:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/pci/cobalt/Kconfig         |    4 ----
 drivers/media/v4l2-core/videobuf2-core.c |    3 ---
 2 files changed, 7 deletions(-)

diff -puN drivers/media/pci/cobalt/Kconfig~linux-next-git-rejects drivers/media/pci/cobalt/Kconfig
--- a/drivers/media/pci/cobalt/Kconfig~linux-next-git-rejects
+++ a/drivers/media/pci/cobalt/Kconfig
@@ -1,12 +1,8 @@
 config VIDEO_COBALT
 	tristate "Cisco Cobalt support"
 	depends on VIDEO_V4L2 && I2C && MEDIA_CONTROLLER
-<<<<<<< HEAD
-	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS && GPIOLIB
-=======
 	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS
 	depends on GPIOLIB || COMPILE_TEST
->>>>>>> linux-next/akpm-base
 	depends on SND
 	select I2C_ALGOBIT
 	select VIDEO_ADV7604
diff -puN drivers/media/v4l2-core/videobuf2-core.c~linux-next-git-rejects drivers/media/v4l2-core/videobuf2-core.c
--- a/drivers/media/v4l2-core/videobuf2-core.c~linux-next-git-rejects
+++ a/drivers/media/v4l2-core/videobuf2-core.c
@@ -1215,11 +1215,8 @@ void vb2_buffer_done(struct vb2_buffer *
 	atomic_dec(&q->owned_by_drv_count);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
-<<<<<<< HEAD
-=======
 	trace_vb2_buf_done(q, vb);
 
->>>>>>> linux-next/akpm-base
 	switch (state) {
 	case VB2_BUF_STATE_QUEUED:
 		return;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
fs-create-and-use-seq_show_option-for-escaping-fix.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume-fix.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
pagemap-update-documentation-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
memory-hot-addedthe-memory-can-not-been-added-to-movable-zone-fix.patch
zswap-dynamic-pool-creation-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-export-idle-flag-via-kpageflags-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
linux-next-rejects.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch
schedh-dont-include-mm_typesh.patch
schedh-dont-include-mm_typesh-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

