From: akpm@linux-foundation.org
Subject: +
 ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch added
 to -mm tree
Date: Thu, 26 Sep 2013 14:08:14 -0700
Message-ID: <5244a23e.3EUfam+VtCIF5jfo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3IZVIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 17:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, akpm@linux-foundation.org

Subject: + ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,manfred@colorfullife.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 14:08:14 -0700


The patch titled
     Subject: ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch

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
Subject: ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes

WARNING: braces {} are not necessary for single statement blocks
#90: FILE: ipc/sem.c:1862:
+	if (error <= 0) {
 		goto out_unlock_free;
 	}

total: 0 errors, 1 warnings, 62 lines checked

./patches/ipc-semc-update-sem_otime-for-all-operations.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes ipc/sem.c
--- a/ipc/sem.c~ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes
+++ a/ipc/sem.c
@@ -1859,9 +1859,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		else
 			set_semotime(sma, sops);
 	}
-	if (error <= 0) {
+	if (error <= 0)
 		goto out_unlock_free;
-	}
 
 	/* We need to sleep on this operation, so we put the current
 	 * task into the pending queue and go to sleep.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch
ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

