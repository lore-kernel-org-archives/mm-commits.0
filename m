From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-compiler-gcch-improve-__visible-documentation.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:45:42 -0800
Message-ID: <5640f7e6.K6sR8ESeH82ZYN43%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbKITpm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compiler-gcc.h: improve __visible documentation
has been removed from the -mm tree.  Its filename was
     include-linux-compiler-gcch-improve-__visible-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/compiler-gcc.h: improve __visible documentation

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc.h~include-linux-compiler-gcch-improve-__visible-documentation include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~include-linux-compiler-gcch-improve-__visible-documentation
+++ a/include/linux/compiler-gcc.h
@@ -205,7 +205,10 @@
 
 #if GCC_VERSION >= 40600
 /*
- * Tell the optimizer that something else uses this function or variable.
+ * When used with Link Time Optimization, gcc can optimize away C functions or
+ * variables which are referenced only from assembly code.  __visible tells the
+ * optimizer that something else uses this function or variable, thus preventing
+ * this.
  */
 #define __visible	__attribute__((externally_visible))
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

