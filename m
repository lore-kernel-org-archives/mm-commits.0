From: akpm@linux-foundation.org
Subject: + exit_thread-remove-empty-bodies-fix.patch added to -mm tree
Date: Thu, 31 Mar 2016 15:30:12 -0700
Message-ID: <56fda4f4.Yr2mbzH5wjCz/z+T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbcCaWaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 18:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: exit_thread-remove-empty-bodies-fix
has been added to the -mm tree.  Its filename is
     exit_thread-remove-empty-bodies-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit_thread-remove-empty-bodies-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exit_thread-remove-empty-bodies-fix.patch

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
Subject: exit_thread-remove-empty-bodies-fix

fix mips

Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/process.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/mips/kernel/process.c~exit_thread-remove-empty-bodies-fix arch/mips/kernel/process.c
--- a/arch/mips/kernel/process.c~exit_thread-remove-empty-bodies-fix
+++ a/arch/mips/kernel/process.c
@@ -73,10 +73,6 @@ void start_thread(struct pt_regs * regs,
 	regs->regs[29] = sp;
 }
 
-void exit_thread(void)
-{
-}
-
 void flush_thread(void)
 {
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

