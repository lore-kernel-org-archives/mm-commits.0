From: akpm@linux-foundation.org
Subject: [folded-merged]
 page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
 removed from -mm tree
Date: Wed, 30 Sep 2015 14:54:52 -0700
Message-ID: <560c5a2c.eblcKmgcRScjoR93%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbbI3Vyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, kirill.shutemov@linux.intel.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags-introduce-page-flags-policies-wrt-compound-pages-fix
has been removed from the -mm tree.  Its filename was
     page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch

This patch was dropped because it was folded into page-flags-introduce-page-flags-policies-wrt-compound-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: page-flags-introduce-page-flags-policies-wrt-compound-pages-fix

undo "kpageidle: decouple from page-flags rework".

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix
+++ a/include/linux/page-flags.h
@@ -316,10 +316,10 @@ PAGEFLAG_FALSE(HWPoison)
 #endif
 
 #if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
-TESTPAGEFLAG(Young, young)
-SETPAGEFLAG(Young, young)
-TESTCLEARFLAG(Young, young)
-PAGEFLAG(Idle, idle)
+TESTPAGEFLAG(Young, young, PF_ANY)
+SETPAGEFLAG(Young, young, PF_ANY)
+TESTCLEARFLAG(Young, young, PF_ANY)
+PAGEFLAG(Idle, idle, PF_ANY)
 #endif
 
 /*
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
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

