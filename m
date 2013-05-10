From: akpm@linux-foundation.org
Subject: - ipcsem-fix-semctl-getzcnt-fix.patch removed from -mm tree
Date: Fri, 10 May 2013 12:26:52 -0700
Message-ID: <20130510192652.EFF4B5A4226@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:50862 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3EJT0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 May 2013 15:26:54 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so414392ghb.3
        for <mm-commits@vger.kernel.org>; Fri, 10 May 2013 12:26:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipcsem-fix-semctl-getzcnt-fix
has been removed from the -mm tree.  Its filename was
     ipcsem-fix-semctl-getzcnt-fix.patch

This patch was dropped because bah

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipcsem-fix-semctl-getzcnt-fix

checkpatch fixes

Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN ipc/sem.c~ipcsem-fix-semctl-getzcnt-fix ipc/sem.c
--- a/ipc/sem.c~ipcsem-fix-semctl-getzcnt-fix
+++ a/ipc/sem.c
@@ -816,7 +816,8 @@ static int count_semzcnt (struct sem_arr
 
 	semzcnt = 0;
 	list_for_each_entry(q, &sma->sem_base[semnum].sem_pending, list) {
-		struct sembuf * sops = q->sops;
+		struct sembuf *sops = q->sops;
+
 		BUG_ON(sops->sem_num != semnum);
 		if ((sops->sem_op == 0) && !(sops->sem_flg & IPC_NOWAIT))
 			semzcnt++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug-fix-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
ipcsem-fix-semctl-getncnt-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

