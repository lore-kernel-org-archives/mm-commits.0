From: akpm@linux-foundation.org
Subject: + task-containersv11-automatic-userspace-notification-of-idle-containers-fix.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:11:43 -0700
Message-ID: <200710151911.l9FJBhhR020296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757123AbXJOTLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pj@sgi.com, menage@google.com


The patch titled
     task containersv11 automatic userspace notification of idle containers fix
has been added to the -mm tree.  Its filename is
     task-containersv11-automatic-userspace-notification-of-idle-containers-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: task containersv11 automatic userspace notification of idle containers fix
From: Paul Jackson <pj@sgi.com>

Need to include kmod.h to define UMH_WAIT_EXEC, at least
for my configuration (sn2_defconfig).

Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/cgroup.c~task-containersv11-automatic-userspace-notification-of-idle-containers-fix kernel/cgroup.c
--- a/kernel/cgroup.c~task-containersv11-automatic-userspace-notification-of-idle-containers-fix
+++ a/kernel/cgroup.c
@@ -43,6 +43,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/sort.h>
+#include <linux/kmod.h>
 #include <asm/atomic.h>
 
 static DEFINE_MUTEX(cgroup_mutex);
_

Patches currently in -mm which might be from pj@sgi.com are

cpuset-remove-sched-domain-hooks-from-cpusets.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-automatic-userspace-notification-of-idle-containers-fix.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
task-containers-enable-containers-by-default-in-some-configs.patch
whitespace-fixes-cpuset.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
