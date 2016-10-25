From: akpm@linux-foundation.org
Subject: +
 prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch added to
 -mm tree
Date: Tue, 25 Oct 2016 16:07:13 -0700
Message-ID: <580fe5a1.M9vIw7qpmcdfeXUZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40353 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbcJYXHP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 19:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, gorcunov@openvz.org, john.stultz@linaro.org, keescook@chromium.org, luto@amacapital.net, matthltc@us.ibm.com, mhocko@suse.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, skinsbursky@virtuozzo.com, vbabka@suse.cz, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: prctl-remove-one-shot-limitation-for-changing-exe-link-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch

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
Subject: prctl-remove-one-shot-limitation-for-changing-exe-link-checkpatch-fixes

fix up comment

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~prctl-remove-one-shot-limitation-for-changing-exe-link-fix include/linux/sched.h
--- a/include/linux/sched.h~prctl-remove-one-shot-limitation-for-changing-exe-link-fix
+++ a/include/linux/sched.h
@@ -520,8 +520,10 @@ static inline int get_dumpable(struct mm
 					/* leave room for more dump flags */
 #define MMF_VM_MERGEABLE	16	/* KSM may merge identical pages */
 #define MMF_VM_HUGEPAGE		17	/* set when VM_HUGEPAGE is set on vma */
-/* This ine-shot flag is droped due to necessivity of changing exe once again
- * on NFS restore */
+/*
+ * This one-shot flag is dropped due to necessity of changing exe once again
+ * on NFS restore
+ */
 //#define MMF_EXE_FILE_CHANGED	18	/* see prctl_set_mm_exe_file() */
 
 #define MMF_HAS_UPROBES		19	/* has uprobes */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

