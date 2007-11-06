From: akpm@linux-foundation.org
Subject: - arch-sparc-remove-duplicate-includes.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:53:32 -0800
Message-ID: <200711060553.lA65rWII007498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50649 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510AbXKFFzs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:55:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: woodzy@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     arch/sparc: remove duplicate includes
has been removed from the -mm tree.  Its filename was
     arch-sparc-remove-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/sparc: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/irq.c           |    1 -
 arch/sparc64/kernel/ds.c          |    1 -
 arch/sparc64/kernel/module.c      |    1 -
 arch/sparc64/kernel/sys_sparc32.c |    1 -
 arch/sparc64/kernel/sys_sunos32.c |    1 -
 arch/sparc64/kernel/time.c        |    2 --
 6 files changed, 7 deletions(-)

diff -puN arch/sparc/kernel/irq.c~arch-sparc-remove-duplicate-includes arch/sparc/kernel/irq.c
--- a/arch/sparc/kernel/irq.c~arch-sparc-remove-duplicate-includes
+++ a/arch/sparc/kernel/irq.c
@@ -18,7 +18,6 @@
 #include <linux/linkage.h>
 #include <linux/kernel_stat.h>
 #include <linux/signal.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/random.h>
diff -puN arch/sparc64/kernel/ds.c~arch-sparc-remove-duplicate-includes arch/sparc64/kernel/ds.c
--- a/arch/sparc64/kernel/ds.c~arch-sparc-remove-duplicate-includes
+++ a/arch/sparc64/kernel/ds.c
@@ -6,7 +6,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
diff -puN arch/sparc64/kernel/module.c~arch-sparc-remove-duplicate-includes arch/sparc64/kernel/module.c
--- a/arch/sparc64/kernel/module.c~arch-sparc-remove-duplicate-includes
+++ a/arch/sparc64/kernel/module.c
@@ -11,7 +11,6 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/mm.h>
 
 #include <asm/processor.h>
diff -puN arch/sparc64/kernel/sys_sparc32.c~arch-sparc-remove-duplicate-includes arch/sparc64/kernel/sys_sparc32.c
--- a/arch/sparc64/kernel/sys_sparc32.c~arch-sparc-remove-duplicate-includes
+++ a/arch/sparc64/kernel/sys_sparc32.c
@@ -51,7 +51,6 @@
 #include <linux/vfs.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/ptrace.h>
-#include <linux/highuid.h>
 
 #include <asm/types.h>
 #include <asm/uaccess.h>
diff -puN arch/sparc64/kernel/sys_sunos32.c~arch-sparc-remove-duplicate-includes arch/sparc64/kernel/sys_sunos32.c
--- a/arch/sparc64/kernel/sys_sunos32.c~arch-sparc-remove-duplicate-includes
+++ a/arch/sparc64/kernel/sys_sunos32.c
@@ -57,7 +57,6 @@
 #include <linux/personality.h>
 
 /* For SOCKET_I */
-#include <linux/socket.h>
 #include <net/sock.h>
 #include <net/compat.h>
 
diff -puN arch/sparc64/kernel/time.c~arch-sparc-remove-duplicate-includes arch/sparc64/kernel/time.c
--- a/arch/sparc64/kernel/time.c~arch-sparc-remove-duplicate-includes
+++ a/arch/sparc64/kernel/time.c
@@ -28,7 +28,6 @@
 #include <linux/jiffies.h>
 #include <linux/cpufreq.h>
 #include <linux/percpu.h>
-#include <linux/profile.h>
 #include <linux/miscdevice.h>
 #include <linux/rtc.h>
 #include <linux/kernel_stat.h>
@@ -47,7 +46,6 @@
 #include <asm/sections.h>
 #include <asm/cpudata.h>
 #include <asm/uaccess.h>
-#include <asm/prom.h>
 #include <asm/irq_regs.h>
 
 DEFINE_SPINLOCK(mostek_lock);
_

Patches currently in -mm which might be from woodzy@gmail.com are

arch-arm-removed-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
arch-ia64-remove-duplicate-includes.patch
arch-mips-remove-duplicate-includes.patch
arch-parisc-remove-duplicate-includes.patch
git-sparc64.patch
arch-x86-remove-duplicate-includes.patch
arch-xtensa-remove-duplicate-includes.patch
arch-alpha-removed-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
