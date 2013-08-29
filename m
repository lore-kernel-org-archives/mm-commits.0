From: akpm@linux-foundation.org
Subject: + h8300-kernel-timer-timer8c-add-missing-semicolon.patch added to -mm tree
Date: Thu, 29 Aug 2013 13:26:47 -0700
Message-ID: <521fae87.Dtw1QqobaEwEsnBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3H2U0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Aug 2013 16:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ysato@users.sourceforge.jp, geert@linux-m68k.org, gang.chen@asianux.com

Subject: + h8300-kernel-timer-timer8c-add-missing-semicolon.patch added to -mm tree
To: gang.chen@asianux.com,geert@linux-m68k.org,ysato@users.sourceforge.jp
From: akpm@linux-foundation.org
Date: Thu, 29 Aug 2013 13:26:47 -0700


The patch titled
     Subject: h8300/kernel/timer/timer8.c: add missing semicolon
has been added to the -mm tree.  Its filename is
     h8300-kernel-timer-timer8c-add-missing-semicolon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/h8300-kernel-timer-timer8c-add-missing-semicolon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/h8300-kernel-timer-timer8c-add-missing-semicolon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: h8300/kernel/timer/timer8.c: add missing semicolon

  arch/h8300/kernel/timer/timer8.c: In function 'h8300_timer_setup':
  arch/h8300/kernel/timer/timer8.c:98:2: error: expected ';' before 'ctrl_outw'

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/timer/timer8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/h8300/kernel/timer/timer8.c~h8300-kernel-timer-timer8c-add-missing-semicolon arch/h8300/kernel/timer/timer8.c
--- a/arch/h8300/kernel/timer/timer8.c~h8300-kernel-timer-timer8c-add-missing-semicolon
+++ a/arch/h8300/kernel/timer/timer8.c
@@ -91,7 +91,7 @@ void __init h8300_timer_setup(void)
 
 #if defined(CONFIG_CPU_H8S)
 	/* Timer module enable */
-	ctrl_bclr(0, MSTPCRL)
+	ctrl_bclr(0, MSTPCRL);
 #endif
 
 	/* initialize timer */
_

Patches currently in -mm which might be from gang.chen@asianux.com are

sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
h8300-kernel-timer-timer8c-add-missing-semicolon.patch
mm-page_allocc-use-__paginginit-instead-of-__init.patch
mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch
mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch
fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str.patch
linux-next.patch
mm-kconfig-add-mmu-dependency-for-migration.patch

