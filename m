From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 02 Nov 2017 12:46:36 -0700
Message-ID: <20171102194636.lnWamkrhz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49154 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932620AbdKBTqi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 15:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c~linux-next-git-rejects drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
diff -puN drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c~linux-next-git-rejects drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
diff -puN fs/ext4/file.c~linux-next-git-rejects fs/ext4/file.c
--- a/fs/ext4/file.c~linux-next-git-rejects
+++ a/fs/ext4/file.c
@@ -1,4 +1,3 @@
-// SPDX-License-Identifier: GPL-2.0
 /*
  *  linux/fs/ext4/file.c
  *
diff -puN init/main.c~linux-next-git-rejects init/main.c
diff -puN kernel/fork.c~linux-next-git-rejects kernel/fork.c
diff -puN include/net/inet_sock.h~linux-next-git-rejects include/net/inet_sock.h
diff -puN Makefile~linux-next-git-rejects Makefile
diff -puN arch/arm64/boot/dts/amlogic/Makefile~linux-next-git-rejects arch/arm64/boot/dts/amlogic/Makefile
--- a/arch/arm64/boot/dts/amlogic/Makefile~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/amlogic/Makefile
@@ -1,8 +1,5 @@
-<<<<<<< HEAD
 # SPDX-License-Identifier: GPL-2.0
-=======
 dtb-$(CONFIG_ARCH_MESON) += meson-axg-s400.dtb
->>>>>>> linux-next/akpm-base
 dtb-$(CONFIG_ARCH_MESON) += meson-gxbb-nanopi-k2.dtb
 dtb-$(CONFIG_ARCH_MESON) += meson-gxbb-nexbox-a95x.dtb
 dtb-$(CONFIG_ARCH_MESON) += meson-gxbb-odroidc2.dtb
diff -puN arch/arm64/boot/dts/arm/Makefile~linux-next-git-rejects arch/arm64/boot/dts/arm/Makefile
--- a/arch/arm64/boot/dts/arm/Makefile~linux-next-git-rejects
+++ a/arch/arm64/boot/dts/arm/Makefile
@@ -1,11 +1,5 @@
-<<<<<<< HEAD
 # SPDX-License-Identifier: GPL-2.0
 dtb-$(CONFIG_ARCH_VEXPRESS) += foundation-v8.dtb foundation-v8-gicv3.dtb
-=======
-dtb-$(CONFIG_ARCH_VEXPRESS) += \
-	foundation-v8.dtb foundation-v8-psci.dtb \
-	foundation-v8-gicv3.dtb foundation-v8-gicv3-psci.dtb
->>>>>>> linux-next/akpm-base
 dtb-$(CONFIG_ARCH_VEXPRESS) += juno.dtb juno-r1.dtb juno-r2.dtb
 dtb-$(CONFIG_ARCH_VEXPRESS) += rtsm_ve-aemv8a.dtb
 dtb-$(CONFIG_ARCH_VEXPRESS) += vexpress-v2f-1xv7-ca53x2.dtb
diff -puN arch/x86/entry/syscalls/Makefile~linux-next-git-rejects arch/x86/entry/syscalls/Makefile
--- a/arch/x86/entry/syscalls/Makefile~linux-next-git-rejects
+++ a/arch/x86/entry/syscalls/Makefile
@@ -1,11 +1,6 @@
-<<<<<<< HEAD
 # SPDX-License-Identifier: GPL-2.0
 out := $(obj)/../../include/generated/asm
 uapi := $(obj)/../../include/generated/uapi/asm
-=======
-out := arch/$(SRCARCH)/include/generated/asm
-uapi := arch/$(SRCARCH)/include/generated/uapi/asm
->>>>>>> linux-next/akpm-base
 
 # Create output directory if not already present
 _dummy := $(shell [ -d '$(out)' ] || mkdir -p '$(out)') \
diff -puN drivers/cdrom/Makefile~linux-next-git-rejects drivers/cdrom/Makefile
--- a/drivers/cdrom/Makefile~linux-next-git-rejects
+++ a/drivers/cdrom/Makefile
@@ -1,4 +1,3 @@
-<<<<<<< HEAD
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for the kernel cdrom device drivers.
 #
@@ -13,7 +12,3 @@ obj-$(CONFIG_PARIDE_PCD)	+=		cdrom.o
 obj-$(CONFIG_CDROM_PKTCDVD)	+=		cdrom.o
 
 obj-$(CONFIG_GDROM)		+= gdrom.o      cdrom.o
-=======
-obj-$(CONFIG_CDROM)	+= cdrom.o
-obj-$(CONFIG_GDROM)	+= gdrom.o
->>>>>>> linux-next/akpm-base
diff -puN drivers/gpu/drm/pl111/Makefile~linux-next-git-rejects drivers/gpu/drm/pl111/Makefile
--- a/drivers/gpu/drm/pl111/Makefile~linux-next-git-rejects
+++ a/drivers/gpu/drm/pl111/Makefile
@@ -1,11 +1,5 @@
-<<<<<<< HEAD
-# SPDX-License-Identifier: GPL-2.0
-pl111_drm-y +=	pl111_connector.o \
-		pl111_display.o \
-=======
 pl111_drm-y +=	pl111_display.o \
 		pl111_versatile.o \
->>>>>>> linux-next/akpm-base
 		pl111_drv.o
 
 pl111_drm-$(CONFIG_DEBUG_FS) += pl111_debugfs.o
diff -puN drivers/gpu/drm/sun4i/Makefile~linux-next-git-rejects drivers/gpu/drm/sun4i/Makefile
--- a/drivers/gpu/drm/sun4i/Makefile~linux-next-git-rejects
+++ a/drivers/gpu/drm/sun4i/Makefile
@@ -1,10 +1,4 @@
-<<<<<<< HEAD
-# SPDX-License-Identifier: GPL-2.0
-sun4i-drm-y += sun4i_drv.o
-sun4i-drm-y += sun4i_framebuffer.o
-=======
 sun4i-backend-y			+= sun4i_backend.o sun4i_layer.o
->>>>>>> linux-next/akpm-base
 
 sun4i-drm-y			+= sun4i_drv.o
 sun4i-drm-y			+= sun4i_framebuffer.o
diff -puN drivers/pci/host/pcie-tango.c~linux-next-git-rejects drivers/pci/host/pcie-tango.c
--- a/drivers/pci/host/pcie-tango.c~linux-next-git-rejects
+++ a/drivers/pci/host/pcie-tango.c
@@ -1,9 +1,5 @@
-<<<<<<< HEAD
-// SPDX-License-Identifier: GPL-2.0
-=======
 #include <linux/irqchip/chained_irq.h>
 #include <linux/irqdomain.h>
->>>>>>> linux-next/akpm-base
 #include <linux/pci-ecam.h>
 #include <linux/delay.h>
 #include <linux/msi.h>
diff -puN drivers/staging/media/atomisp/i2c/ov5693/Makefile~linux-next-git-rejects drivers/staging/media/atomisp/i2c/ov5693/Makefile
--- a/drivers/staging/media/atomisp/i2c/ov5693/Makefile~linux-next-git-rejects
+++ a/drivers/staging/media/atomisp/i2c/ov5693/Makefile
@@ -1,9 +1,4 @@
-<<<<<<< HEAD
-# SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_VIDEO_OV5693) += ov5693.o
-=======
 obj-$(CONFIG_VIDEO_ATOMISP_OV5693) += atomisp-ov5693.o
->>>>>>> linux-next/akpm-base
 
 # HACK! While this driver is in bad shape, don't enable several warnings
 #       that would be otherwise enabled with W=1
diff -puN drivers/thermal/tegra/Makefile~linux-next-git-rejects drivers/thermal/tegra/Makefile
--- a/drivers/thermal/tegra/Makefile~linux-next-git-rejects
+++ a/drivers/thermal/tegra/Makefile
@@ -1,10 +1,5 @@
-<<<<<<< HEAD
-# SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_TEGRA_SOCTHERM)	+= tegra-soctherm.o
-=======
 obj-$(CONFIG_TEGRA_SOCTHERM)		+= tegra-soctherm.o
 obj-$(CONFIG_TEGRA_BPMP_THERMAL)	+= tegra-bpmp-thermal.o
->>>>>>> linux-next/akpm-base
 
 tegra-soctherm-y				:= soctherm.o soctherm-fuse.o
 tegra-soctherm-$(CONFIG_ARCH_TEGRA_124_SOC)	+= tegra124-soctherm.o
diff -puN include/linux/compiler-clang.h~linux-next-git-rejects include/linux/compiler-clang.h
--- a/include/linux/compiler-clang.h~linux-next-git-rejects
+++ a/include/linux/compiler-clang.h
@@ -1,9 +1,4 @@
-<<<<<<< HEAD
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_COMPILER_H
-=======
 #ifndef __LINUX_COMPILER_TYPES_H
->>>>>>> linux-next/akpm-base
 #error "Please don't include <linux/compiler-clang.h> directly, include <linux/compiler.h> instead."
 #endif
 
diff -puN include/linux/compiler-gcc.h~linux-next-git-rejects include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~linux-next-git-rejects
+++ a/include/linux/compiler-gcc.h
@@ -1,9 +1,4 @@
-<<<<<<< HEAD
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_COMPILER_H
-=======
 #ifndef __LINUX_COMPILER_TYPES_H
->>>>>>> linux-next/akpm-base
 #error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
 #endif
 
diff -puN include/linux/compiler-intel.h~linux-next-git-rejects include/linux/compiler-intel.h
--- a/include/linux/compiler-intel.h~linux-next-git-rejects
+++ a/include/linux/compiler-intel.h
@@ -1,9 +1,4 @@
-<<<<<<< HEAD
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_COMPILER_H
-=======
 #ifndef __LINUX_COMPILER_TYPES_H
->>>>>>> linux-next/akpm-base
 #error "Please don't include <linux/compiler-intel.h> directly, include <linux/compiler.h> instead."
 #endif
 
diff -puN include/uapi/linux/stddef.h~linux-next-git-rejects include/uapi/linux/stddef.h
--- a/include/uapi/linux/stddef.h~linux-next-git-rejects
+++ a/include/uapi/linux/stddef.h
@@ -1,9 +1,5 @@
-<<<<<<< HEAD
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #include <linux/compiler.h>
-=======
-#include <linux/compiler_types.h>
->>>>>>> linux-next/akpm-base
 
 #ifndef __always_inline
 #define __always_inline inline
diff -puN kernel/cgroup/Makefile~linux-next-git-rejects kernel/cgroup/Makefile
--- a/kernel/cgroup/Makefile~linux-next-git-rejects
+++ a/kernel/cgroup/Makefile
@@ -1,9 +1,4 @@
-<<<<<<< HEAD
-# SPDX-License-Identifier: GPL-2.0
 obj-y := cgroup.o namespace.o cgroup-v1.o
-=======
-obj-y := cgroup.o stat.o namespace.o cgroup-v1.o
->>>>>>> linux-next/akpm-base
 
 obj-$(CONFIG_CGROUP_FREEZER) += freezer.o
 obj-$(CONFIG_CGROUP_PIDS) += pids.o
diff -puN tools/perf/arch/arm64/annotate/instructions.c~linux-next-git-rejects tools/perf/arch/arm64/annotate/instructions.c
--- a/tools/perf/arch/arm64/annotate/instructions.c~linux-next-git-rejects
+++ a/tools/perf/arch/arm64/annotate/instructions.c
@@ -1,8 +1,5 @@
-<<<<<<< HEAD
 // SPDX-License-Identifier: GPL-2.0
-=======
 #include <linux/compiler.h>
->>>>>>> linux-next/akpm-base
 #include <sys/types.h>
 #include <regex.h>
 
diff -puN tools/perf/arch/arm/annotate/instructions.c~linux-next-git-rejects tools/perf/arch/arm/annotate/instructions.c
--- a/tools/perf/arch/arm/annotate/instructions.c~linux-next-git-rejects
+++ a/tools/perf/arch/arm/annotate/instructions.c
@@ -1,8 +1,5 @@
-<<<<<<< HEAD
 // SPDX-License-Identifier: GPL-2.0
-=======
 #include <linux/compiler.h>
->>>>>>> linux-next/akpm-base
 #include <sys/types.h>
 #include <regex.h>
 
diff -puN tools/perf/arch/powerpc/annotate/instructions.c~linux-next-git-rejects tools/perf/arch/powerpc/annotate/instructions.c
--- a/tools/perf/arch/powerpc/annotate/instructions.c~linux-next-git-rejects
+++ a/tools/perf/arch/powerpc/annotate/instructions.c
@@ -1,9 +1,6 @@
-<<<<<<< HEAD
 // SPDX-License-Identifier: GPL-2.0
-=======
 #include <linux/compiler.h>
 
->>>>>>> linux-next/akpm-base
 static struct ins_ops *powerpc__associate_instruction_ops(struct arch *arch, const char *name)
 {
 	int i;
diff -puN tools/perf/arch/s390/annotate/instructions.c~linux-next-git-rejects tools/perf/arch/s390/annotate/instructions.c
--- a/tools/perf/arch/s390/annotate/instructions.c~linux-next-git-rejects
+++ a/tools/perf/arch/s390/annotate/instructions.c
@@ -1,9 +1,6 @@
-<<<<<<< HEAD
 // SPDX-License-Identifier: GPL-2.0
-=======
 #include <linux/compiler.h>
 
->>>>>>> linux-next/akpm-base
 static struct ins_ops *s390__associate_ins_ops(struct arch *arch, const char *name)
 {
 	struct ins_ops *ops = NULL;
diff -puN tools/perf/ui/tui/progress.c~linux-next-git-rejects tools/perf/ui/tui/progress.c
--- a/tools/perf/ui/tui/progress.c~linux-next-git-rejects
+++ a/tools/perf/ui/tui/progress.c
@@ -1,8 +1,5 @@
-<<<<<<< HEAD
 // SPDX-License-Identifier: GPL-2.0
-=======
 #include <linux/kernel.h>
->>>>>>> linux-next/akpm-base
 #include "../cache.h"
 #include "../progress.h"
 #include "../libslang.h"
diff -puN tools/perf/util/zlib.c~linux-next-git-rejects tools/perf/util/zlib.c
--- a/tools/perf/util/zlib.c~linux-next-git-rejects
+++ a/tools/perf/util/zlib.c
@@ -1,8 +1,5 @@
-<<<<<<< HEAD
 // SPDX-License-Identifier: GPL-2.0
-=======
 #include <fcntl.h>
->>>>>>> linux-next/akpm-base
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/stat.h>
diff -puN tools/thermal/tmon/Makefile~linux-next-git-rejects tools/thermal/tmon/Makefile
--- a/tools/thermal/tmon/Makefile~linux-next-git-rejects
+++ a/tools/thermal/tmon/Makefile
@@ -1,10 +1,7 @@
-<<<<<<< HEAD
 # SPDX-License-Identifier: GPL-2.0
-=======
 # We need this for the "cc-option" macro.
 include ../../../scripts/Kbuild.include
 
->>>>>>> linux-next/akpm-base
 VERSION = 1.0
 
 BINDIR=usr/bin
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-deferred_init_memmap-improvements-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

