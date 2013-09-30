From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 30 Sep 2013 13:41:53 -0700
Message-ID: <5249e211.Ik64wOnBARAHOnHm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab3I3Uly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Sep 2013 16:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, akpm@linux-foundation.org

Subject: [folded-merged] ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 30 Sep 2013 13:41:53 -0700


The patch titled
     Subject: ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-semc-update-sem_otime-for-all-operations.patch

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists.patch
ipc-semc-update-sem_otime-for-all-operations.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
memblock-factor-out-of-top-down-allocation-hack.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

