From: akpm@linux-foundation.org
Subject: + dma-mapping-tidy-up-dma_parms-default-handling-fix.patch added
 to -mm tree
Date: Wed, 30 Sep 2015 15:23:08 -0700
Message-ID: <560c60cc.VVh+NiOpOEZVogLD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbbI3WXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 18:23:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, m.szyprowski@samsung.com, rmk+kernel@arm.linux.org.uk, robin.murphy@arm.com, sakari.ailus@iki.fi, sumit.semwal@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping-tidy-up-dma_parms-default-handling-fix
has been added to the -mm tree.  Its filename is
     dma-mapping-tidy-up-dma_parms-default-handling-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-tidy-up-dma_parms-default-handling-fix.patch

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
Subject: dma-mapping-tidy-up-dma_parms-default-handling-fix

dma-mapping.h needs sizes.h for SZ_64K

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/dma-mapping.h~dma-mapping-tidy-up-dma_parms-default-handling-fix include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-tidy-up-dma_parms-default-handling-fix
+++ a/include/linux/dma-mapping.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_DMA_MAPPING_H
 #define _LINUX_DMA_MAPPING_H
 
+#include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/device.h>
 #include <linux/err.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
memcg-make-mem_cgroup_read_stat-unsigned-fix.patch
drivers-input-joystick-kconfig-zhenhuac-needs-bitreverse.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
linux-next-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

