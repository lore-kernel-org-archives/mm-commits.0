From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 04 Mar 2013 16:33:06 -0800
Message-ID: <20130305003306.819105A4123@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:44561 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3CEAdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Mar 2013 19:33:07 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so674295ghb.4
        for <mm-commits@vger.kernel.org>; Mon, 04 Mar 2013 16:33:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-dove/board-dt.c |    4 ----
 fs/nfsd/nfs4state.c           |    4 ----
 2 files changed, 8 deletions(-)

diff -puN arch/arm/mach-dove/board-dt.c~linux-next-git-rejects arch/arm/mach-dove/board-dt.c
--- a/arch/arm/mach-dove/board-dt.c~linux-next-git-rejects
+++ a/arch/arm/mach-dove/board-dt.c
@@ -85,11 +85,7 @@ DT_MACHINE_START(DOVE_DT, "Marvell Dove 
 	.map_io		= dove_map_io,
 	.init_early	= dove_init_early,
 	.init_irq	= orion_dt_init_irq,
-<<<<<<< HEAD
-	.init_time	= dove_timer_init,
-=======
 	.init_time      = dove_timer_init,
->>>>>>> linux-next/akpm-base
 	.init_machine	= dove_dt_init,
 	.restart	= dove_restart,
 	.dt_compat	= dove_dt_board_compat,
diff -puN fs/nfsd/nfs4state.c~linux-next-git-rejects fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~linux-next-git-rejects
+++ a/fs/nfsd/nfs4state.c
@@ -1079,10 +1079,6 @@ free_client(struct nfs4_client *clp)
 	}
 	free_svc_cred(&clp->cl_cred);
 	kfree(clp->cl_name.data);
-<<<<<<< HEAD
-=======
-	idr_remove_all(&clp->cl_stateids);
->>>>>>> linux-next/akpm-base
 	idr_destroy(&clp->cl_stateids);
 	kfree(clp);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
shmem-fix-build-regression-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

