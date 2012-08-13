From: akpm@linux-foundation.org
Subject: + mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch added to -mm tree
Date: Mon, 13 Aug 2012 14:59:23 -0700
Message-ID: <20120813224646.B21CD1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52542 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2HMWqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Aug 2012 18:46:48 -0400
Received: by obbwc20 with SMTP id wc20so3293294obb.1
        for <mm-commits@vger.kernel.org>; Mon, 13 Aug 2012 15:46:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, khlebnikov@openvz.org


The patch titled
     Subject: mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix
has been added to the -mm tree.  Its filename is
     mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix

Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/pci/vfio_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/unevictable-lru.txt~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix Documentation/vm/unevictable-lru.txt
diff -puN arch/alpha/kernel/pci-sysfs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix arch/alpha/kernel/pci-sysfs.c
diff -puN arch/ia64/kernel/perfmon.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix arch/ia64/kernel/perfmon.c
diff -puN arch/ia64/mm/init.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix arch/ia64/mm/init.c
diff -puN arch/powerpc/kvm/book3s_hv.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix arch/powerpc/kvm/book3s_hv.c
diff -puN arch/sparc/kernel/pci.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix arch/sparc/kernel/pci.c
diff -puN arch/unicore32/kernel/process.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix arch/unicore32/kernel/process.c
diff -puN arch/x86/xen/mmu.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix arch/x86/xen/mmu.c
diff -puN drivers/char/mbcs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/char/mbcs.c
diff -puN drivers/char/mem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/char/mem.c
diff -puN drivers/char/mspec.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/char/mspec.c
diff -puN drivers/gpu/drm/drm_gem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/gpu/drm/drm_gem.c
diff -puN drivers/gpu/drm/drm_vm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/gpu/drm/drm_vm.c
diff -puN drivers/gpu/drm/exynos/exynos_drm_gem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/gpu/drm/exynos/exynos_drm_gem.c
diff -puN drivers/gpu/drm/gma500/framebuffer.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/gpu/drm/gma500/framebuffer.c
diff -puN drivers/gpu/drm/ttm/ttm_bo_vm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/gpu/drm/ttm/ttm_bo_vm.c
diff -puN drivers/gpu/drm/udl/udl_fb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/gpu/drm/udl/udl_fb.c
diff -puN drivers/infiniband/hw/ehca/ehca_uverbs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/infiniband/hw/ehca/ehca_uverbs.c
diff -puN drivers/infiniband/hw/ipath/ipath_file_ops.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/infiniband/hw/ipath/ipath_file_ops.c
diff -puN drivers/infiniband/hw/qib/qib_file_ops.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/infiniband/hw/qib/qib_file_ops.c
diff -puN drivers/media/video/meye.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/media/video/meye.c
diff -puN drivers/media/video/omap/omap_vout.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/media/video/omap/omap_vout.c
diff -puN drivers/media/video/sn9c102/sn9c102_core.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/media/video/sn9c102/sn9c102_core.c
diff -puN drivers/media/video/usbvision/usbvision-video.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/media/video/usbvision/usbvision-video.c
diff -puN drivers/media/video/videobuf-dma-sg.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/media/video/videobuf-dma-sg.c
diff -puN drivers/media/video/videobuf-vmalloc.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/media/video/videobuf-vmalloc.c
diff -puN drivers/media/video/videobuf2-memops.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/media/video/videobuf2-memops.c
diff -puN drivers/media/video/vino.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/media/video/vino.c
diff -puN drivers/misc/carma/carma-fpga.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/misc/carma/carma-fpga.c
diff -puN drivers/misc/sgi-gru/grufile.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/misc/sgi-gru/grufile.c
diff -puN drivers/mtd/mtdchar.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/mtd/mtdchar.c
diff -puN drivers/scsi/sg.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/scsi/sg.c
diff -puN drivers/staging/omapdrm/omap_gem_dmabuf.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/staging/omapdrm/omap_gem_dmabuf.c
diff -puN drivers/staging/tidspbridge/rmgr/drv_interface.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/staging/tidspbridge/rmgr/drv_interface.c
diff -puN drivers/uio/uio.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/uio/uio.c
diff -puN drivers/usb/mon/mon_bin.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/usb/mon/mon_bin.c
diff -puN drivers/video/68328fb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/68328fb.c
diff -puN drivers/video/aty/atyfb_base.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/aty/atyfb_base.c
diff -puN drivers/video/fb-puv3.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/fb-puv3.c
diff -puN drivers/video/fb_defio.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/fb_defio.c
diff -puN drivers/video/fbmem.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/fbmem.c
diff -puN drivers/video/gbefb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/gbefb.c
diff -puN drivers/video/omap2/omapfb/omapfb-main.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/omap2/omapfb/omapfb-main.c
diff -puN drivers/video/sbuslib.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/sbuslib.c
diff -puN drivers/video/smscufx.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/smscufx.c
diff -puN drivers/video/udlfb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/udlfb.c
diff -puN drivers/video/vermilion/vermilion.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/vermilion/vermilion.c
diff -puN drivers/video/vfb.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/video/vfb.c
diff -puN drivers/xen/gntalloc.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/xen/gntalloc.c
diff -puN drivers/xen/gntdev.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/xen/gntdev.c
diff -puN drivers/xen/privcmd.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/xen/privcmd.c
diff -puN fs/binfmt_elf.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix fs/binfmt_elf.c
diff -puN fs/binfmt_elf_fdpic.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix fs/binfmt_elf_fdpic.c
diff -puN fs/hugetlbfs/inode.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix fs/hugetlbfs/inode.c
diff -puN fs/proc/task_mmu.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix fs/proc/task_mmu.c
diff -puN include/linux/mempolicy.h~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix include/linux/mempolicy.h
diff -puN include/linux/mm.h~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix include/linux/mm.h
diff -puN include/linux/mm_types.h~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix include/linux/mm_types.h
diff -puN kernel/events/core.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix kernel/events/core.c
diff -puN mm/ksm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix mm/ksm.c
diff -puN mm/memory.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix mm/memory.c
diff -puN mm/mlock.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix mm/mlock.c
diff -puN mm/mmap.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix mm/mmap.c
diff -puN mm/nommu.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix mm/nommu.c
diff -puN mm/vmalloc.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix mm/vmalloc.c
diff -puN security/selinux/selinuxfs.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix security/selinux/selinuxfs.c
diff -puN sound/core/pcm_native.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix sound/core/pcm_native.c
diff -puN sound/usb/usx2y/us122l.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix sound/usb/usx2y/us122l.c
diff -puN sound/usb/usx2y/usX2Yhwdep.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix sound/usb/usx2y/usX2Yhwdep.c
diff -puN sound/usb/usx2y/usx2yhwdeppcm.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix sound/usb/usx2y/usx2yhwdeppcm.c
diff -puN drivers/vfio/pci/vfio_pci.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix drivers/vfio/pci/vfio_pci.c
--- a/drivers/vfio/pci/vfio_pci.c~mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix
+++ a/drivers/vfio/pci/vfio_pci.c
@@ -461,7 +461,7 @@ static int vfio_pci_mmap(void *device_da
 	}
 
 	vma->vm_private_data = vdev;
-	vma->vm_flags |= (VM_IO | VM_RESERVED);
+	vma->vm_flags |= VM_IO;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 
 	phys = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
thermal-add-generic-cpufreq-cooling-implementation.patch
thermal-exynos5-add-exynos5-thermal-sensor-driver-support.patch
thermal-exynos-register-the-tmu-sensor-with-the-kernel-thermal-layer.patch
mm-slab_commonc-fix-warning.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
rbtree-performance-and-correctness-test-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

