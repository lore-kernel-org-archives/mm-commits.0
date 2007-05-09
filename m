From: akpm@linux-foundation.org
Subject: - nfsd-nfs4state-remove-unnecessary-daemonize-call.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:54 -0700
Message-ID: <200705092152.l49LqsM1003035@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759470AbXEIVxY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfsd/nfs4state: remove unnecessary daemonize call
has been removed from the -mm tree.  Its filename was
     nfsd-nfs4state-remove-unnecessary-daemonize-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfsd/nfs4state: remove unnecessary daemonize call
From: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/nfsd/nfs4state.c~nfsd-nfs4state-remove-unnecessary-daemonize-call fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~nfsd-nfs4state-remove-unnecessary-daemonize-call
+++ a/fs/nfsd/nfs4state.c
@@ -1326,8 +1326,6 @@ do_recall(void *__dp)
 {
 	struct nfs4_delegation *dp = __dp;
 
-	daemonize("nfsv4-recall");
-
 	nfsd4_cb_recall(dp);
 	return 0;
 }
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
iop13xx-msi-support-rev6.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
x86_64-display-more-intutive-error-message-if-kernel-is-not-2mb-aligned.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
