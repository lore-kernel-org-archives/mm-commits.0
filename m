From: akpm@linux-foundation.org
Subject: - use-defines-in-sys_getpriority-sys_setpriority-fix.patch removed from -mm tree
Date: Thu, 10 May 2007 21:50:59 -0700
Message-ID: <200705110450.l4B4oxrc006400@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbXEKEvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 00:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dwalker@mvista.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     use-defines-in-sys_getpriority-sys_setpriority-fix
has been removed from the -mm tree.  Its filename was
     use-defines-in-sys_getpriority-sys_setpriority-fix.patch

This patch was dropped because it was folded into use-defines-in-sys_getpriority-sys_setpriority.patch

------------------------------------------------------
Subject: use-defines-in-sys_getpriority-sys_setpriority-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN kernel/sys.c~use-defines-in-sys_getpriority-sys_setpriority-fix kernel/sys.c
--- a/kernel/sys.c~use-defines-in-sys_getpriority-sys_setpriority-fix
+++ a/kernel/sys.c
@@ -14,6 +14,7 @@
 #include <linux/prctl.h>
 #include <linux/highuid.h>
 #include <linux/fs.h>
+#include <linux/resource.h>
 #include <linux/kernel.h>
 #include <linux/kexec.h>
 #include <linux/workqueue.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-hexdump.patch
stop_machine-now-uses-hard_irq_disable.patch
submitchecklist-add-W-help.patch
tty-add-compat_ioctl.patch
use-defines-in-sys_getpriority-sys_setpriority.patch
use-defines-in-sys_getpriority-sys_setpriority-fix.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
pm3fb-preliminary-24-to-26-port-fix.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
