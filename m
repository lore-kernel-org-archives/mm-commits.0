From: akpm@linux-foundation.org
Subject: + include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
 added to -mm tree
Date: Thu, 24 Mar 2016 15:39:38 -0700
Message-ID: <56f46caa.AkTBKoWWP0gZ8aSJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbcCXWjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2016 18:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: include-linux-apply-__malloc-attribute-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     include-linux-apply-__malloc-attribute-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-apply-__malloc-attribute-checkpatch-fixes.patch

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
Subject: include-linux-apply-__malloc-attribute-checkpatch-fixes

ERROR: "foo * bar" should be "foo *bar"
#171: FILE: include/linux/mempool.h:35:
+extern void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempool.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bootmem.h~include-linux-apply-__malloc-attribute-checkpatch-fixes include/linux/bootmem.h
diff -puN include/linux/device.h~include-linux-apply-__malloc-attribute-checkpatch-fixes include/linux/device.h
diff -puN include/linux/kernel.h~include-linux-apply-__malloc-attribute-checkpatch-fixes include/linux/kernel.h
diff -puN include/linux/mempool.h~include-linux-apply-__malloc-attribute-checkpatch-fixes include/linux/mempool.h
--- a/include/linux/mempool.h~include-linux-apply-__malloc-attribute-checkpatch-fixes
+++ a/include/linux/mempool.h
@@ -32,7 +32,7 @@ extern mempool_t *mempool_create_node(in
 
 extern int mempool_resize(mempool_t *pool, int new_min_nr);
 extern void mempool_destroy(mempool_t *pool);
-extern void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;
+extern void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
 
 /*
diff -puN include/linux/slab.h~include-linux-apply-__malloc-attribute-checkpatch-fixes include/linux/slab.h
diff -puN include/linux/string.h~include-linux-apply-__malloc-attribute-checkpatch-fixes include/linux/string.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
sched-add-schedule_timeout_idle.patch
drivers-input-eliminate-input_compat_test-macro.patch
mm-kasan-stackdepot-implementation-enable-stackdepot-for-slab-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

