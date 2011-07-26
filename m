From: akpm@linux-foundation.org
Subject: [folded] ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:57:07 -0700
Message-ID: <201107262257.p6QMv7P3014661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733Ab1GZW6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:58:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.lezcano@free.fr, ebiederm@xmission.com, mingo@elte.hu, oleg@redhat.com, rdunlap@xenotime.net, segoon@openwall.com, serge.hallyn@canonical.com, tj@ker


The patch titled
     ipc-introduce-shm_rmid_forced-sysctl-fix-2
has been removed from the -mm tree.  Its filename was
     ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch

This patch was dropped because it was folded into ipc-introduce-shm_rmid_forced-sysctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc-introduce-shm_rmid_forced-sysctl-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

include/linux/shm.h: In function 'exit_shm':
include/linux/shm.h:122: warning: 'return' with a value, in function returning void

Testing?


Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shm.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/shm.h~ipc-introduce-shm_rmid_forced-sysctl-fix-2 include/linux/shm.h
--- a/include/linux/shm.h~ipc-introduce-shm_rmid_forced-sysctl-fix-2
+++ a/include/linux/shm.h
@@ -119,7 +119,6 @@ static inline int is_file_shm_hugepages(
 }
 static inline void exit_shm(struct task_struct *task)
 {
-	return 0;
 }
 #endif
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch

