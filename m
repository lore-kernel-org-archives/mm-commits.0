From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-apm_32c-remove-duplicated-include.patch added to -mm tree
Date: Mon, 18 Aug 2008 14:04:20 -0700
Message-ID: <200808182104.m7IL4KK0012641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbYHRVE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 17:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, mingo@elte.hu, pavel@suse.cz, tglx@linutronix.de


The patch titled
     arch/x86/kernel/apm_32.c: remove duplicated #include
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-apm_32c-remove-duplicated-include.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
arch-x86-kernel-apm_32c-remove-duplicated-include.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

