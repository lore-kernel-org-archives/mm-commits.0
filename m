From: akpm@linux-foundation.org
Subject: + ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch added to -mm tree
Date: Tue, 16 Jul 2013 15:52:43 -0700
Message-ID: <51e5cebb.qGifkkPc2+VzzgcD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479Ab3GPWwo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jul 2013 18:52:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr.bueso@hp.com, akpm@linux-foundation.org

Subject: + ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,davidlohr.bueso@hp.com
From: akpm@linux-foundation.org
Date: Tue, 16 Jul 2013 15:52:43 -0700


The patch titled
     Subject: ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch

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
Subject: ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes

WARNING: space prohibited between function name and open parenthesis '('
#65: FILE: ipc/shm.c:921:
+		if (copy_shmid_to_user (buf, &tbuf, version))

total: 0 errors, 1 warnings, 54 lines checked

./patches/ipcshm-make-shmctl_nolock-lockless.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/shm.c~ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes ipc/shm.c
--- a/ipc/shm.c~ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes
+++ a/ipc/shm.c
@@ -918,7 +918,7 @@ static int shmctl_nolock(struct ipc_name
 		tbuf.shm_nattch	= shp->shm_nattch;
 		rcu_read_unlock();
 
-		if (copy_shmid_to_user (buf, &tbuf, version))
+		if (copy_shmid_to_user(buf, &tbuf, version))
 			err = -EFAULT;
 		else
 			err = result;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
mm.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

