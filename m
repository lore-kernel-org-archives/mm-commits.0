From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 14 Nov 2016 12:01:47 -0800
Message-ID: <582a182b.qQAueXJRn4qSXp5/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938478AbcKNUBs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 15:01:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/amd.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN arch/x86/kernel/cpu/amd.c~linux-next-git-rejects arch/x86/kernel/cpu/amd.c
--- a/arch/x86/kernel/cpu/amd.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/amd.c
@@ -372,18 +372,6 @@ static void amd_detect_cmp(struct cpuinf
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 	amd_get_topology(c);
-<<<<<<< HEAD
-
-	/*
-	 * Fix percpu cpu_llc_id here as LLC topology is different
-	 * for Fam17h systems.
-	 */
-	 if (c->x86 != 0x17 || !cpuid_edx(0x80000006))
-		return;
-
-	per_cpu(cpu_llc_id, cpu) = c->apicid >> 3;
-=======
->>>>>>> linux-next/akpm-base
 #endif
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

