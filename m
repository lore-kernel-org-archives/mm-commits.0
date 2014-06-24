From: akpm@linux-foundation.org
Subject: +
 ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
 added to -mm tree
Date: Tue, 24 Jun 2014 13:01:46 -0700
Message-ID: <53a9d92a.Go23kycozuRY6W6E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFXUBr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 16:01:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, fengguang.wu@intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: PPC, KVM: fix build failure due to removed file
has been added to the -mm tree.  Its filename is
     ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: PPC, KVM: fix build failure due to removed file

Commit ('PPC, KVM, CMA: use general CMA reserved area management
framework') removes book3s_hv_cma.c, but, missed to remove entry
in Makefile. Fix it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/Makefile |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/powerpc/kvm/Makefile~ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix arch/powerpc/kvm/Makefile
--- a/arch/powerpc/kvm/Makefile~ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix
+++ a/arch/powerpc/kvm/Makefile
@@ -90,7 +90,6 @@ kvm-book3s_64-builtin-objs-$(CONFIG_KVM_
 	book3s_hv_rm_mmu.o \
 	book3s_hv_ras.o \
 	book3s_hv_builtin.o \
-	book3s_hv_cma.o \
 	$(kvm-book3s_64-builtin-xics-objs-y)
 endif
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
memcg-cleanup-memcg_cache_params-refcnt-usage.patch
memcg-destroy-kmem-caches-when-last-slab-is-freed.patch
memcg-mark-caches-that-belong-to-offline-memcgs-as-dead.patch
slub-dont-fail-kmem_cache_shrink-if-slab-placement-optimization-fails.patch
slub-make-slab_free-non-preemptable.patch
memcg-wait-for-kfrees-to-finish-before-destroying-cache.patch
slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch
slab-do-not-keep-free-objects-slabs-on-dead-memcg-caches.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
cma-generalize-cma-reserved-area-management-functionality.patch
cma-generalize-cma-reserved-area-management-functionality-fix.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
page-owners-correct-page-order-when-to-free-page.patch

