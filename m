From: akpm@linux-foundation.org
Subject: [to-be-updated] proc-pid-fdinfo-add-cloexec-information-fix.patch removed from -mm tree
Date: Tue, 26 Jul 2011 14:20:22 -0700
Message-ID: <201107262120.p6QLKM4e009703@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542Ab1GZVU3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 17:20:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, drepper@gmail.com, kosaki.motohiro@jp.fujitsu.com, mtk.manpages@gmail.com, rientjes@google.com, viro@zeniv.linux.org.uk, wilsons@start.c


The patch titled
     proc-pid-fdinfo-add-cloexec-information-fix
has been removed from the -mm tree.  Its filename was
     proc-pid-fdinfo-add-cloexec-information-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc-pid-fdinfo-add-cloexec-information-fix
From: Andrew Morton <akpm@linux-foundation.org>

use a tab for consistency

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Stephen Wilson <wilsons@start.ca>
Cc: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/base.c~proc-pid-fdinfo-add-cloexec-information-fix fs/proc/base.c
--- a/fs/proc/base.c~proc-pid-fdinfo-add-cloexec-information-fix
+++ a/fs/proc/base.c
@@ -1935,7 +1935,7 @@ static int proc_fd_info(struct inode *in
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
 					 "flags:\t0%o\n"
-					 "cloexec: %d\n",
+					 "cloexec:\t%d\n",
 					 (long long) file->f_pos,
 					 file->f_flags,
 					 cloexec);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
vmware-balloon-switch-to-using-sysem-wide-freezable-workqueue-fix.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

