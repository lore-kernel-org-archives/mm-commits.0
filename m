From: akpm@linux-foundation.org
Subject: + powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch
 added to -mm tree
Date: Wed, 27 Jul 2016 12:37:29 -0700
Message-ID: <57990d79.+qfX5EEQu4EDVBUC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbcG0Tha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, benh@kernel.crashing.org, mpe@ellerman.id.au, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix
has been added to the -mm tree.  Its filename is
     powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

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
Subject: powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix

Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -698,11 +698,6 @@ int fsl_rio_setup(struct platform_device
 			RIO_INB_ATMU_REGS_PORT2_OFFSET));
 
 
-		/* Set to receive any dist ID for serial RapidIO controller. */
-		if (port->phy_type == RIO_PHY_SERIAL)
-			out_be32((priv->regs_win
-				+ RIO_ISR_AACR + i*0x80), RIO_ISR_AACR_AA);
-
 		/* Configure maintenance transaction window */
 		out_be32(&priv->maint_atmu_regs->rowbar,
 			port->iores.start >> 12);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-bail-out-in-shrin_inactive_list-fix.patch
revert-mm-mempool-only-set-__gfp_nomemalloc-if-there-are-free-elements-checkpatch-fixes.patch
mm-optimize-copy_page_to-from_iter_iovec-fix.patch
mm-optimize-copy_page_to-from_iter_iovec-fix-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-resriction-on-the-kexec_load-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

