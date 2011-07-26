From: akpm@linux-foundation.org
Subject: [folded] ipc-introduce-shm_rmid_forced-sysctl-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:57:01 -0700
Message-ID: <201107262257.p6QMv18q014648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751892Ab1GZW5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rdunlap@xenotime.net, segoon@openwall.com, mm-commits@vger.kernel.org


The patch titled
     ipc-introduce-shm_rmid_forced-sysctl-fix
has been removed from the -mm tree.  Its filename was
     ipc-introduce-shm_rmid_forced-sysctl-fix.patch

This patch was dropped because it was folded into ipc-introduce-shm_rmid_forced-sysctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc-introduce-shm_rmid_forced-sysctl-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix documentation, per Randy

Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/kernel.txt~ipc-introduce-shm_rmid_forced-sysctl-fix Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~ipc-introduce-shm_rmid_forced-sysctl-fix
+++ a/Documentation/sysctl/kernel.txt
@@ -521,7 +521,7 @@ kernel.  This value defaults to SHMMAX.
 
 shm_rmid_forced:
 
-Linux lets you set resource limits, including on how much memory one
+Linux lets you set resource limits, including how much memory one
 process can consume, via setrlimit(2).  Unfortunately, shared memory
 segments are allowed to exist without association with any process, and
 thus might not be counted against any resource limits.  If enabled,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch

