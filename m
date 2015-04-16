From: akpm@linux-foundation.org
Subject: [merged]
 mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:59 -0700
Message-ID: <552fe8eb.zYT3L9O/M/8azKKE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbDPQrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.mateosian@samsung.com, d.safonov@partner.samsung.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, pintu.k@samsung.com, stefan.strogin@gmail.com, v.tyrtov@samsung.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma_debug.c: remove blank lines before DEFINE_SIMPLE_ATTRIBUTE()
has been removed from the -mm tree.  Its filename was
     mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/cma_debug.c: remove blank lines before DEFINE_SIMPLE_ATTRIBUTE()

Like EXPORT_SYMBOL(): the positioning communicates that the macro pertains
to the immediately preceding function.

Cc: Dmitry Safonov <d.safonov@partner.samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Stefan Strogin <stefan.strogin@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pintu Kumar <pintu.k@samsung.com>
Cc: Weijie Yang <weijie.yang@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: Aleksei Mateosian <a.mateosian@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/cma_debug.c~mm-cma_debugc-remove-blank-lines-before-define_simple_attribute mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma_debugc-remove-blank-lines-before-define_simple_attribute
+++ a/mm/cma_debug.c
@@ -30,7 +30,6 @@ static int cma_debugfs_get(void *data, u
 
 	return 0;
 }
-
 DEFINE_SIMPLE_ATTRIBUTE(cma_debugfs_fops, cma_debugfs_get, NULL, "%llu\n");
 
 static int cma_used_get(void *data, u64 *val)
@@ -46,7 +45,6 @@ static int cma_used_get(void *data, u64
 
 	return 0;
 }
-
 DEFINE_SIMPLE_ATTRIBUTE(cma_used_fops, cma_used_get, NULL, "%llu\n");
 
 static int cma_maxchunk_get(void *data, u64 *val)
@@ -68,7 +66,6 @@ static int cma_maxchunk_get(void *data,
 
 	return 0;
 }
-
 DEFINE_SIMPLE_ATTRIBUTE(cma_maxchunk_fops, cma_maxchunk_get, NULL, "%llu\n");
 
 static void cma_add_to_cma_mem_list(struct cma *cma, struct cma_mem *mem)
@@ -129,7 +126,6 @@ static int cma_free_write(void *data, u6
 
 	return cma_free_mem(cma, pages);
 }
-
 DEFINE_SIMPLE_ATTRIBUTE(cma_free_fops, NULL, cma_free_write, "%llu\n");
 
 static int cma_alloc_mem(struct cma *cma, int count)
@@ -162,7 +158,6 @@ static int cma_alloc_write(void *data, u
 
 	return cma_alloc_mem(cma, pages);
 }
-
 DEFINE_SIMPLE_ATTRIBUTE(cma_alloc_fops, NULL, cma_alloc_write, "%llu\n");
 
 static void cma_debugfs_add_one(struct cma *cma, int idx)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kernel-forkc-avoid-division-by-zero-fix.patch
kernel-forkc-avoid-division-by-zero-fix-fix.patch
doc-sysctl-kerneltxt-document-threads-max-fix.patch
mm-rcu-protected-get_mm_exe_file-fix-2.patch
affs-kstrdup-memory-handling-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

