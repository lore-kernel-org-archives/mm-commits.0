From: akpm@linux-foundation.org
Subject: - arch-x86-kernel-apm_32c-remove-duplicated-include.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:44:51 -0700
Message-ID: <200808261844.m7QIipi7021346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757529AbYHZSps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyi.huang@gmail.com, mingo@elte.hu, pavel@suse.cz, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/apm_32.c: remove duplicated #include
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-apm_32c-remove-duplicated-include.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/apm_32.c: remove duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated include file <linux/smp_lock.h> in
arch/x86/kernel/apm_32.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Acked-by: Pavel Machek <pavel@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/apm_32.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/kernel/apm_32.c~arch-x86-kernel-apm_32c-remove-duplicated-include arch/x86/kernel/apm_32.c
--- a/arch/x86/kernel/apm_32.c~arch-x86-kernel-apm_32c-remove-duplicated-include
+++ a/arch/x86/kernel/apm_32.c
@@ -228,7 +228,6 @@
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>
-#include <linux/smp_lock.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

