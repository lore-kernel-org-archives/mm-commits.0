From: akpm@linux-foundation.org
Subject: [merged]
 genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:48:26 -0700
Message-ID: <559adb8a.EZvxqvZXQGAULoa2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbbGFTs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, atull@opensource.altera.com, broonie@kernel.org, dinguyen@opensource.altera.com, khilman@linaro.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/arm/mach-socfpga/pm.c: s/get_gen_pool/get_gen_pool/
has been removed from the -mm tree.  Its filename was
     genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/arm/mach-socfpga/pm.c: s/get_gen_pool/get_gen_pool/

I fat-fingered the fix to "genalloc: rename dev_get_gen_pool() to
gen_pool_get()"

Cc: Alan Tull <atull@opensource.altera.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-socfpga/pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-socfpga/pm.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix arch/arm/mach-socfpga/pm.c
--- a/arch/arm/mach-socfpga/pm.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix
+++ a/arch/arm/mach-socfpga/pm.c
@@ -56,7 +56,7 @@ static int socfpga_setup_ocram_self_refr
 		goto put_node;
 	}
 
-	ocram_pool = get_gen_pool(&pdev->dev);
+	ocram_pool = gen_pool_get(&pdev->dev);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
linux-next.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

