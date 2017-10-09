From: akpm@linux-foundation.org
Subject: + pid-remove-pidhash-checkpatch-fixes.patch added to -mm tree
Date: Mon, 09 Oct 2017 16:21:31 -0700
Message-ID: <59dc047b.6jLW8bamDjGMM5Hg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754784AbdJIXVc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Oct 2017 19:21:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gs051095@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pid-remove-pidhash-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     pid-remove-pidhash-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pid-remove-pidhash-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pid-remove-pidhash-checkpatch-fixes.patch

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
Subject: pid-remove-pidhash-checkpatch-fixes

ERROR: space required before the open parenthesis '('
#136: FILE: kernel/pid.c:121:
+		switch(--ns->pid_allocated) {

total: 1 errors, 0 warnings, 188 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/pid-remove-pidhash.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Gargi Sharma <gs051095@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid.c~pid-remove-pidhash-checkpatch-fixes kernel/pid.c
--- a/kernel/pid.c~pid-remove-pidhash-checkpatch-fixes
+++ a/kernel/pid.c
@@ -118,7 +118,7 @@ void free_pid(struct pid *pid)
 	for (i = 0; i <= pid->level; i++) {
 		struct upid *upid = pid->numbers + i;
 		struct pid_namespace *ns = upid->ns;
-		switch(--ns->pid_allocated) {
+		switch (--ns->pid_allocated) {
 		case 2:
 		case 1:
 			/* When all that is left in the pid namespace
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
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
pid-replace-pid-bitmap-implementation-with-idr-api-checkpatch-fixes.patch
pid-remove-pidhash-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

