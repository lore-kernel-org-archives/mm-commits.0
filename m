From: akpm@linux-foundation.org
Subject: + h8300-time-add-missing-include-asm-irq_regsh.patch added to -mm tree
Date: Tue, 26 Jun 2012 16:50:28 -0700
Message-ID: <20120626235028.EC324A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54530 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2FZXua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jun 2012 19:50:30 -0400
Received: by wgbdt11 with SMTP id dt11so23055wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Jun 2012 16:50:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, tony@bakeyournoodle.com, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300/time: add missing #include <asm/irq_regs.h>
has been added to the -mm tree.  Its filename is
     h8300-time-add-missing-include-asm-irq_regsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: h8300/time: add missing #include <asm/irq_regs.h>

arch/h8300/kernel/time.c: In function 'h8300_timer_tick':
arch/h8300/kernel/time.c:39:2: error: implicit declaration of function 'get_irq_regs' [-Werror=implicit-function-declaration]
arch/h8300/kernel/time.c:39:42: error: invalid type argument of '->' (have 'int')

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/h8300/kernel/time.c~h8300-time-add-missing-include-asm-irq_regsh arch/h8300/kernel/time.c
--- a/arch/h8300/kernel/time.c~h8300-time-add-missing-include-asm-irq_regsh
+++ a/arch/h8300/kernel/time.c
@@ -27,6 +27,7 @@
 #include <linux/profile.h>
 
 #include <asm/io.h>
+#include <asm/irq_regs.h>
 #include <asm/timer.h>
 
 #define	TICK_SIZE (tick_nsec / 1000)
_
Subject: Subject: h8300/time: add missing #include <asm/irq_regs.h>

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
mn10300-move-setup_jiffies_interrupt-to-cevt-mn10300c.patch
mn10300-remove-duplicate-definition-of-ptrace_o_tracesysgood.patch
mn10300-kernel-internalh-needs-linux-irqreturnh.patch
mn10300-kernel-trapsc-needs-linux-exporth.patch
mn10300-mm-dma-allocc-needs-linux-exporth.patch
mn10300-use-elif-definedconfig_-instead-of-elif-config_.patch
h8300-pgtable-add-missing-include-asm-generic-pgtableh.patch
h8300-signal-fix-typo-statis.patch
h8300-time-add-missing-include-asm-irq_regsh.patch
h8300-uaccess-remove-assignment-to-__gu_val-in-unhandled-case-of-get_user.patch
h8300-uaccess-add-mising-__clear_user.patch

