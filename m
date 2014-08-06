From: akpm@linux-foundation.org
Subject: [folded-merged]
 ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 15:45:41 -0700
Message-ID: <53e2b015.G+OMsvAQ2BYrpu+f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:36783 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaHFWpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:45:43 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so608146oig.5
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:45:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, fengguang.wu@intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: PPC, KVM: fix build failure due to removed file
has been removed from the -mm tree.  Its filename was
     ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch

This patch was dropped because it was folded into ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch

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

mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
mm-trivial-comment-cleanup-in-slabc.patch
mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
dma-cma-separate-core-cma-management-codes-from-dma-apis.patch
dma-cma-support-alignment-constraint-on-cma-region.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
cma-generalize-cma-reserved-area-management-functionality.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework.patch
mm-cma-clean-up-cma-allocation-error-path.patch
mm-cma-change-cma_declare_contiguous-to-obey-coding-convention.patch
mm-cma-clean-up-log-message.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
kernel-smpc-on_each_cpu_cond-fix-warning-in-fallback-path.patch

