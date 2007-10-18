From: akpm@linux-foundation.org
Subject: - clean-up-duplicate-includes-in-kernel.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:46 -0700
Message-ID: <200710180653.l9I6rkYP030471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932539AbXJRHoh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:44:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, paulmck@linux.vnet.ibm.com, ssatyam@cse.iitk.ac.in, mm-commits@vger.kernel.org


The patch titled
     Clean up duplicate includes in kernel/
has been removed from the -mm tree.  Its filename was
     clean-up-duplicate-includes-in-kernel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clean up duplicate includes in kernel/
From: Jesper Juhl <jesper.juhl@gmail.com>

This patch cleans up duplicate includes in
	kernel/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c    |    1 -
 kernel/exit.c       |    1 -
 kernel/kexec.c      |    1 -
 kernel/rcupdate.c   |    1 -
 kernel/rcutorture.c |    1 -
 kernel/taskstats.c  |    1 -
 kernel/time.c       |    1 -
 7 files changed, 7 deletions(-)

diff -puN kernel/auditsc.c~clean-up-duplicate-includes-in-kernel kernel/auditsc.c
--- a/kernel/auditsc.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/auditsc.c
@@ -45,7 +45,6 @@
 #include <linux/init.h>
 #include <asm/types.h>
 #include <asm/atomic.h>
-#include <asm/types.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/mm.h>
diff -puN kernel/exit.c~clean-up-duplicate-includes-in-kernel kernel/exit.c
--- a/kernel/exit.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/exit.c
@@ -44,7 +44,6 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff -puN kernel/kexec.c~clean-up-duplicate-includes-in-kernel kernel/kexec.c
--- a/kernel/kexec.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/kexec.c
@@ -17,7 +17,6 @@
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
-#include <linux/syscalls.h>
 #include <linux/ioport.h>
 #include <linux/hardirq.h>
 #include <linux/elf.h>
diff -puN kernel/rcupdate.c~clean-up-duplicate-includes-in-kernel kernel/rcupdate.c
--- a/kernel/rcupdate.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/rcupdate.c
@@ -45,7 +45,6 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
-#include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 
diff -puN kernel/rcutorture.c~clean-up-duplicate-includes-in-kernel kernel/rcutorture.c
--- a/kernel/rcutorture.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/rcutorture.c
@@ -35,7 +35,6 @@
 #include <linux/sched.h>
 #include <asm/atomic.h>
 #include <linux/bitops.h>
-#include <linux/module.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
diff -puN kernel/taskstats.c~clean-up-duplicate-includes-in-kernel kernel/taskstats.c
--- a/kernel/taskstats.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/taskstats.c
@@ -20,7 +20,6 @@
 #include <linux/taskstats_kern.h>
 #include <linux/tsacct_kern.h>
 #include <linux/delayacct.h>
-#include <linux/tsacct_kern.h>
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
 #include <net/genetlink.h>
diff -puN kernel/time.c~clean-up-duplicate-includes-in-kernel kernel/time.c
--- a/kernel/time.c~clean-up-duplicate-includes-in-kernel
+++ a/kernel/time.c
@@ -34,7 +34,6 @@
 #include <linux/syscalls.h>
 #include <linux/security.h>
 #include <linux/fs.h>
-#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-cifs.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
