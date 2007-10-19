From: akpm@linux-foundation.org
Subject: - whitespace-fixes-time-syscalls.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:30 -0700
Message-ID: <200710190343.l9J3hUGq013066@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966261AbXJSD4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     whitespace fixes: time syscalls
has been removed from the -mm tree.  Its filename was
     whitespace-fixes-time-syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: whitespace fixes: time syscalls
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/time.c~whitespace-fixes-time-syscalls kernel/time.c
--- a/kernel/time.c~whitespace-fixes-time-syscalls
+++ a/kernel/time.c
@@ -9,9 +9,9 @@
  */
 /*
  * Modification history kernel/time.c
- * 
+ *
  * 1993-09-02    Philip Gladstone
- *      Created file with time related functions from sched.c and adjtimex() 
+ *      Created file with time related functions from sched.c and adjtimex()
  * 1993-10-08    Torsten Duwe
  *      adjtime interface update and CMOS clock write code
  * 1995-08-13    Torsten Duwe
@@ -39,7 +39,7 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
-/* 
+/*
  * The timezone where the local system is located.  Used as a default by some
  * programs who obtain this value by using gettimeofday.
  */
@@ -72,7 +72,7 @@ asmlinkage long sys_time(time_t __user *
  * why not move it into the appropriate arch directory (for those
  * architectures that need it).
  */
- 
+
 asmlinkage long sys_stime(time_t __user *tptr)
 {
 	struct timespec tv;
@@ -111,10 +111,10 @@ asmlinkage long sys_gettimeofday(struct 
 /*
  * Adjust the time obtained from the CMOS to be UTC time instead of
  * local time.
- * 
+ *
  * This is ugly, but preferable to the alternatives.  Otherwise we
  * would either need to write a program to do it in /etc/rc (and risk
- * confusion if the program gets run more than once; it would also be 
+ * confusion if the program gets run more than once; it would also be
  * hard to make the program warp the clock precisely n hours)  or
  * compile in the timezone information into the kernel.  Bad, bad....
  *
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
whitespace-fixes-task-exit-handling.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
