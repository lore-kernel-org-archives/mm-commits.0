From: akpm@linux-foundation.org
Subject: + uml-path_max-needs-limitsh.patch added to -mm tree
Date: Tue, 03 Jun 2008 12:31:20 -0700
Message-ID: <200806031931.m53JVKAh015913@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753912AbYFCTbb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 15:31:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, jdike@linux.intel.com


The patch titled
     uml: PATH_MAX needs limits.h
has been added to the -mm tree.  Its filename is
     uml-path_max-needs-limitsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: PATH_MAX needs limits.h
From: Ingo Molnar <mingo@elte.hu>

Include limits.h to get a definition of PATH_MAX.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/helper.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/os-Linux/helper.c~uml-path_max-needs-limitsh arch/um/os-Linux/helper.c
--- a/arch/um/os-Linux/helper.c~uml-path_max-needs-limitsh
+++ a/arch/um/os-Linux/helper.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <sched.h>
+#include <linux/limits.h>
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include "kern_constants.h"
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
uml-path_max-needs-limitsh.patch
linux-next.patch
git-x86-fixup.patch
kgdb-use-put_unaligned_be32-helper.patch
lguest-use-cpu-capability-accessors.patch
sched-delete-dead-stuff.patch
sched-delete-dead-stuff-2.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
aes-x86_64-asm-implementation-optimization.patch
provide-rtc_cmos-platform-device-take-2.patch
acpi-fix-drivers-acpi-gluec-build-error.patch
aperture_64c-corner-case-wrong.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
pm-boot-time-suspend-selftest.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch
introduce-have_efficient_unaligned_access-kconfig-symbol.patch
percpu-introduce-define_per_cpu_page_aligned.patch
remove-argument-from-open_softirq-which-is-always-null.patch
build-kernel-profileo-only-when-requested.patch
build-kernel-profileo-only-when-requested-cleanups.patch
kernel-irq-managec-replace-a-printk-warn_on-to-a-warn.patch
rtc-remove-and-clarify-unneeded-externs.patch
markers-use-rcu_barrier_sched-and-call_rcu_sched.patch
accounting-account-for-user-time-when-updating-memory-integrals.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
kgdb-use-the-common-ascii-hex-helpers.patch
common-implementation-of-iterative-div-mod.patch
add-an-inlined-version-of-iter_div_u64_rem.patch
always_inline-timespec_add_ns.patch
gcov-architecture-specific-compile-flag-adjustments.patch
gcov-architecture-specific-compile-flag-adjustments-fix.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch

