From: akpm@linux-foundation.org
Subject: + genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch
 added to -mm tree
Date: Mon, 29 Jun 2015 16:04:00 -0700
Message-ID: <5591cee0.jvnblubgfpzMwpcM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbF2XEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 19:04:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, atull@opensource.altera.com, broonie@kernel.org, dinguyen@opensource.altera.com, khilman@linaro.org, nicolas.ferre@atmel.com, sfr@canb.auug.org.au, vladimir_zapolskiy@mentor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix
has been added to the -mm tree.  Its filename is
     genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch

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
Subject: genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix

update arch/arm/mach-socfpga/pm.c

Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alan Tull <atull@opensource.altera.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
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
 
-	ocram_pool = dev_get_gen_pool(&pdev->dev);
+	ocram_pool = get_gen_pool(&pdev->dev);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
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
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
linux-next.patch
drivers-block-nvme-corec-fix-build-with-gcc-444.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

