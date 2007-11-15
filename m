From: akpm@linux-foundation.org
Subject: - pidns-place-under-config_experimental-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 Nov 2007 16:45:14 -0800
Message-ID: <200711150045.lAF0jEO6002052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbXKOAqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 19:46:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bunk@kernel.org, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, jeremy@goop.org, kir@swsoft.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pidns-place-under-config_experimental-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pidns-place-under-config_experimental-checkpatch-fixes.patch

This patch was dropped because it was folded into pidns-place-under-config_experimental.patch

------------------------------------------------------
Subject: pidns-place-under-config_experimental-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#60: FILE: include/linux/pid_namespace.h:57:
+static inline struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns)

total: 0 errors, 1 warnings, 66 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Adrian Bunk <bunk@kernel.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Kir Kolyshkin <kir@swsoft.com>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/pid_namespace.h~pidns-place-under-config_experimental-checkpatch-fixes include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pidns-place-under-config_experimental-checkpatch-fixes
+++ a/include/linux/pid_namespace.h
@@ -54,7 +54,8 @@ static inline struct pid_namespace *get_
 	return ns;
 }
 
-static inline struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns)
+static inline struct pid_namespace *
+copy_pid_ns(unsigned long flags, struct pid_namespace *ns)
 {
 	if (flags & CLONE_NEWPID)
 		ns = ERR_PTR(-EINVAL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
uml-update-address-space-affected-by-pud_clear.patch
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks.patch
acpi-make-acpi_procfs-default-to-y.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components.patch
revert-task-control-groups-example-cpu-accounting-subsystem.patch
mips-undo-locking-on-error-path-returns.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
aic94xx_sds-rename-flash_size.patch
mips-pcspkr-build-fix.patch
