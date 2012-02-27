From: akpm@linux-foundation.org
Subject: [merged] sh-remove-unnecessary-posix_typesh-type-overrides.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:29:57 -0800
Message-ID: <20120227222957.6B198A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:59019 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2B0W36 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:29:58 -0500
Received: by qcsp5 with SMTP id p5so416037qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:29:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: remove unnecessary posix_types.h type overrides
has been removed from the -mm tree.  Its filename was
     sh-remove-unnecessary-posix_typesh-type-overrides.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: sh: remove unnecessary posix_types.h type overrides

Remove type overrides in <asm/posix_types.h> for the sh architecture that
are no longer necessary.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/posix_types_32.h |    5 -----
 arch/sh/include/asm/posix_types_64.h |    4 ----
 2 files changed, 9 deletions(-)

diff -puN arch/sh/include/asm/posix_types_32.h~sh-remove-unnecessary-posix_typesh-type-overrides arch/sh/include/asm/posix_types_32.h
--- a/arch/sh/include/asm/posix_types_32.h~sh-remove-unnecessary-posix_typesh-type-overrides
+++ a/arch/sh/include/asm/posix_types_32.h
@@ -12,11 +12,6 @@ typedef unsigned short	__kernel_uid_t;
 typedef unsigned short	__kernel_gid_t;
 #define __kernel_gid_t __kernel_gid_t
 
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
-
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
 typedef unsigned short	__kernel_old_gid_t;
diff -puN arch/sh/include/asm/posix_types_64.h~sh-remove-unnecessary-posix_typesh-type-overrides arch/sh/include/asm/posix_types_64.h
--- a/arch/sh/include/asm/posix_types_64.h~sh-remove-unnecessary-posix_typesh-type-overrides
+++ a/arch/sh/include/asm/posix_types_64.h
@@ -17,10 +17,6 @@ typedef int		__kernel_ssize_t;
 #define __kernel_ssize_t __kernel_ssize_t
 typedef int		__kernel_ptrdiff_t;
 #define __kernel_ptrdiff_t __kernel_ptrdiff_t
-typedef unsigned int	__kernel_uid32_t;
-#define __kernel_uid32_t __kernel_uid32_t
-typedef unsigned int	__kernel_gid32_t;
-#define __kernel_gid32_t __kernel_gid32_t
 
 typedef unsigned short	__kernel_old_uid_t;
 #define __kernel_old_uid_t __kernel_old_uid_t
_

Patches currently in -mm which might be from hpa@zytor.com are

origin.patch
linux-next.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
platform-x86-kill-off-moorestown.patch
intel_scu_ipc-remove-moorestown-support.patch
platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch
platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch
platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch
intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch
intel_mid_powerbtn-mark-irq-as-irqf_no_suspend.patch
x86-olpc-add-debugfs-interface-for-ec-commands.patch
x86-mm-fix-the-size-calculation-of-mapping-tables.patch
alix2-supplement-driver-to-include-gpio-button-support.patch
net5501-platform-driver-for-soekris-engineering-net5501-single-board-computer.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable.patch
x86-change-percpu_read_stable-to-this_cpu_read_stable-fix.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
percpu-remove-percpu_xxx-functions.patch
smp-start-up-non-boot-cpus-asynchronously.patch
smp-start-up-non-boot-cpus-asynchronously-fix.patch
bitops-rename-for_each_set_bit_cont-in-favor-of-analogous-listh-function.patch
bitops-remove-for_each_set_bit_cont.patch
bitops-introduce-for_each_clear_bit.patch
x86-use-for_each_clear_bit_from.patch
ipc-provide-generic-compat-versions-of-ipc-syscalls.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch

