From: akpm@linux-foundation.org
Subject: +
 mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch added to -mm tree
Date: Tue, 03 Oct 2017 15:30:33 -0700
Message-ID: <59d40f89.T82gliSAxWNq4/X2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56904 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdJCWae (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 18:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix
has been added to the -mm tree.  Its filename is
     mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch

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
Subject: mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix

fix spello in comment

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix
+++ a/mm/swap_slots.c
@@ -149,7 +149,7 @@ static int alloc_swap_slot_cache(unsigne
 	cache->cur = 0;
 	cache->n_ret = 0;
 	/*
-	 * We intialized alloc_lock and free_lock earlier.  We use
+	 * We initialized alloc_lock and free_lock earlier.  We use
 	 * !cache->slots or !cache->slots_ret to know if it is safe to acquire
 	 * the corresponding lock and use the cache.  Memory barrier below
 	 * ensures the assumption.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

