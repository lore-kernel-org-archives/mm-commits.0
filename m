From: akpm@linux-foundation.org
Subject: [wrecked] h8300-kernel-timer-timer8c-add-missing-semicolon.patch
 removed from -mm tree
Date: Fri, 13 Sep 2013 12:37:45 -0700
Message-ID: <52336989.SVh5yKFlac08frVc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3IMThq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 15:37:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ysato@users.sourceforge.jp, geert@linux-m68k.org, gang.chen@asianux.com

Subject: [wrecked] h8300-kernel-timer-timer8c-add-missing-semicolon.patch removed from -mm tree
To: gang.chen@asianux.com,geert@linux-m68k.org,ysato@users.sourceforge.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 12:37:45 -0700


The patch titled
     Subject: h8300/kernel/timer/timer8.c: add missing semicolon
has been removed from the -mm tree.  Its filename was
     h8300-kernel-timer-timer8c-add-missing-semicolon.patch

This patch was dropped because other changes were merged, which wrecked this patch

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

origin.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
linux-next.patch

