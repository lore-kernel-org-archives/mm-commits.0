From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 ipc-convert-ipcs_idr-to-xarray-update-fix.patch removed from -mm tree
Date: Tue, 09 Jun 2020 20:59:34 -0700
Message-ID: <20200610035934.sE65e9H1s%akpm@linux-foundation.org>
References: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgFJD7g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 9 Jun 2020 23:59:36 -0400
In-Reply-To: <20200608212922.5b7fa74ca3f4e2444441b7f9@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, longman@redhat.com, manfred@colorfullife.com, mingo@redhat.com, mm-commits@vger.kernel.org, neilb@suse.com, oberpar@linux.ibm.com, rostedt@goodmis.org, schwab@suse.de, vvs@virtuozzo.com


The patch titled
     Subject: ipc-convert-ipcs_idr-to-xarray-update-fix
has been removed from the -mm tree.  Its filename was
     ipc-convert-ipcs_idr-to-xarray-update-fix.patch

This patch was dropped because it was folded into ipc-convert-ipcs_idr-to-xarray.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-convert-ipcs_idr-to-xarray-update-fix

fix conflict resolution fix

Cc: Andreas Schwab <schwab@suse.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: NeilBrown <neilb@suse.com>
Cc: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/ipc/util.c~ipc-convert-ipcs_idr-to-xarray-update-fix
+++ a/ipc/util.c
@@ -766,7 +766,7 @@ static struct kern_ipc_perm *sysvipc_fin
 		ipc_lock_object(ipc);
 	else
 		rcu_read_unlock();
-	*new_pos = pos + 1;
+	*new_pos = index + 1;
 	return ipc;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-sparc-mm-srmmuc-fix-build.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
lib-test-get_count_order-long-in-test_bitopsc-fix.patch
lib-test-get_count_order-long-in-test_bitopsc-fix-fix.patch
ipc-convert-ipcs_idr-to-xarray.patch
mm-pass-task-and-mm-to-do_madvise.patch
mm-introduce-external-memory-hinting-api-fix-2-fix.patch
mm-support-vector-address-ranges-for-process_madvise-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
