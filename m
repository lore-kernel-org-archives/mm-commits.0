From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Mon, 23 May 2016 13:03:14 -0700
Message-ID: <57436202.hwiyjlHpu6uGaB3g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbcEWUDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 16:03:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/Kconfig   |   56 ++++++++++++++++--------------------------
 include/linux/efi.h |    1 
 2 files changed, 23 insertions(+), 34 deletions(-)

diff -puN arch/tile/Kconfig~linux-next-rejects arch/tile/Kconfig
--- a/arch/tile/Kconfig~linux-next-rejects
+++ a/arch/tile/Kconfig
@@ -4,48 +4,36 @@
 config TILE
 	def_bool y
 	select HAVE_EXIT_THREAD
-	select HAVE_PERF_EVENTS
-	select USE_PMC if PERF_EVENTS
-	select HAVE_DMA_API_DEBUG
-	select HAVE_KVM if !TILEGX
-	select GENERIC_FIND_FIRST_BIT
-	select SYSCTL_EXCEPTION_TRACE
-	select CC_OPTIMIZE_FOR_SIZE
-	select HAVE_DEBUG_KMEMLEAK
-	select GENERIC_IRQ_PROBE
-	select GENERIC_PENDING_IRQ if SMP
-	select GENERIC_IRQ_SHOW
-	select HAVE_DEBUG_BUGVERBOSE
-	select VIRT_TO_BUS
-	select SYS_HYPERVISOR
-	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEVMEM_IS_ALLOWED
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select GENERIC_CLOCKEVENTS
-	select MODULES_USE_ELF_RELA
-	select HAVE_ARCH_TRACEHOOK
-	select HAVE_SYSCALL_TRACEPOINTS
-	select USER_STACKTRACE_SUPPORT
-	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
-	select HAVE_DEBUG_STACKOVERFLOW
 	select ARCH_WANT_FRAME_POINTERS
-	select HAVE_CONTEXT_TRACKING
+	select CC_OPTIMIZE_FOR_SIZE
 	select HAVE_NMI if USE_PMC
 	select EDAC_SUPPORT
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_IRQ_PROBE
+	select GENERIC_IRQ_SHOW
+	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_ARCH_SECCOMP_FILTER
-
-# FIXME: investigate whether we need/want these options.
-#	select HAVE_IOREMAP_PROT
-#	select HAVE_OPTPROBES
-#	select HAVE_REGS_AND_STACK_ACCESS_API
-#	select HAVE_HW_BREAKPOINT
-#	select PERF_EVENTS
-#	select HAVE_USER_RETURN_NOTIFIER
-#	config NO_BOOTMEM
-#	config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-#	config HUGETLB_PAGE_SIZE_VARIABLE
+	select HAVE_ARCH_TRACEHOOK
+	select HAVE_CONTEXT_TRACKING
+	select HAVE_DEBUG_BUGVERBOSE
+	select HAVE_DEBUG_KMEMLEAK
+	select HAVE_DEBUG_STACKOVERFLOW
+	select HAVE_DMA_API_DEBUG
+	select HAVE_KVM if !TILEGX
+	select HAVE_PERF_EVENTS
+	select HAVE_SYSCALL_TRACEPOINTS
+	select MODULES_USE_ELF_RELA
+	select SYSCTL_EXCEPTION_TRACE
+	select SYS_HYPERVISOR
+	select USER_STACKTRACE_SUPPORT
+	select USE_PMC if PERF_EVENTS
+	select VIRT_TO_BUS
 
 config MMU
 	def_bool y
diff -puN include/linux/efi.h~linux-next-rejects include/linux/efi.h
--- a/include/linux/efi.h~linux-next-rejects
+++ a/include/linux/efi.h
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/proc_fs.h>
 #include <linux/rtc.h>
+#include <linux/screen_info.h>
 #include <linux/ioport.h>
 #include <linux/pfn.h>
 #include <linux/pstore.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-thp-avoid-unnecessary-swapin-in-khugepaged-fix.patch
allocate-idle-task-for-a-cpu-always-on-its-local-node-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

