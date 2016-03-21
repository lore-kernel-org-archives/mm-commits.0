From: akpm@linux-foundation.org
Subject: [merged] arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:03 -0700
Message-ID: <56f0403f.NccKl+Cf9AqtuQar%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbcCUT43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, josh@joshtriplett.org, lkp@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/mn10300/kernel/fpu-nofpu.c: needs asm/elf.h
has been removed from the -mm tree.  Its filename was
     arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/mn10300/kernel/fpu-nofpu.c: needs asm/elf.h

arch/mn10300/kernel/fpu-nofpu.c:27:36: error: unknown type name 'elf_fpregset_t'
    int dump_fpu(struct pt_regs *regs, elf_fpregset_t *fpreg)

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/fpu-nofpu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/mn10300/kernel/fpu-nofpu.c~arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh arch/mn10300/kernel/fpu-nofpu.c
--- a/arch/mn10300/kernel/fpu-nofpu.c~arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh
+++ a/arch/mn10300/kernel/fpu-nofpu.c
@@ -9,6 +9,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 #include <asm/fpu.h>
+#include <asm/elf.h>
 
 /*
  * handle an FPU operational exception
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

