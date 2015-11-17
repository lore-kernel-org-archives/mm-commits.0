From: akpm@linux-foundation.org
Subject: + include-define-__phys_to_pfn-as-phys_pfn-fix.patch added to -mm tree
Date: Tue, 17 Nov 2015 13:52:15 -0800
Message-ID: <564ba18f.zBfDWIlAX92E+180%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbbKQVwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 16:52:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gang.chen.5i5j@gmail.com, xili_gchen_5257@hotmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include-define-__phys_to_pfn-as-phys_pfn-fix
has been added to the -mm tree.  Its filename is
     include-define-__phys_to_pfn-as-phys_pfn-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-define-__phys_to_pfn-as-phys_pfn-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-define-__phys_to_pfn-as-phys_pfn-fix.patch

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
Subject: include-define-__phys_to_pfn-as-phys_pfn-fix

use macro arg name `x'

Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Chen Gang <xili_gchen_5257@hotmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pfn.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pfn.h~include-define-__phys_to_pfn-as-phys_pfn-fix include/linux/pfn.h
--- a/include/linux/pfn.h~include-define-__phys_to_pfn-as-phys_pfn-fix
+++ a/include/linux/pfn.h
@@ -9,6 +9,6 @@
 #define PFN_UP(x)	(((x) + PAGE_SIZE-1) >> PAGE_SHIFT)
 #define PFN_DOWN(x)	((x) >> PAGE_SHIFT)
 #define PFN_PHYS(x)	((phys_addr_t)(x) << PAGE_SHIFT)
-#define PHYS_PFN(y)	((unsigned long)((y) >> PAGE_SHIFT))
+#define PHYS_PFN(x)	((unsigned long)((x) >> PAGE_SHIFT))
 
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ncpfs-dont-allow-negative-timeouts-fix.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

