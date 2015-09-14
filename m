From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-srcu-ify-shrinkers-fix-fix.patch removed from
 -mm tree
Date: Mon, 14 Sep 2015 10:45:46 -0700
Message-ID: <55f707ca.PuvwJL0TKf5eXr5N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50176 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbbINRpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-srcu-ify-shrinkers-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-srcu-ify-shrinkers-fix-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-srcu-ify-shrinkers-fix-fix

all architectures

Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |    1 -
 init/Kconfig         |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/Kconfig~mm-srcu-ify-shrinkers-fix-fix arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~mm-srcu-ify-shrinkers-fix-fix
+++ a/arch/powerpc/Kconfig
@@ -127,7 +127,6 @@ config PPC
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select IRQ_FORCED_THREADING
-	select SRCU
 	select HAVE_RCU_TABLE_FREE if SMP
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_BPF_JIT
diff -puN init/Kconfig~mm-srcu-ify-shrinkers-fix-fix init/Kconfig
--- a/init/Kconfig~mm-srcu-ify-shrinkers-fix-fix
+++ a/init/Kconfig
@@ -513,6 +513,7 @@ config RCU_EXPERT
 
 config SRCU
 	bool
+	default y
 	help
 	  This option selects the sleepable version of RCU. This version
 	  permits arbitrary sleeping or blocking within RCU read-side critical
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

