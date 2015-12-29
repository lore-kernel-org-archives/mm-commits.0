From: akpm@linux-foundation.org
Subject: + exit-remove-unneeded-declaration-of-exit_mm.patch added to -mm
 tree
Date: Tue, 29 Dec 2015 13:18:10 -0800
Message-ID: <5682f892.SCUTUAUiYkQcWTA0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbbL2VSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Dec 2015 16:18:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 0x7f454c46@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: remove unneeded declaration of exit_mm()
has been added to the -mm tree.  Its filename is
     exit-remove-unneeded-declaration-of-exit_mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-remove-unneeded-declaration-of-exit_mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exit-remove-unneeded-declaration-of-exit_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: exit: remove unneeded declaration of exit_mm()

Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/exit.c~exit-remove-unneeded-declaration-of-exit_mm kernel/exit.c
--- a/kernel/exit.c~exit-remove-unneeded-declaration-of-exit_mm
+++ a/kernel/exit.c
@@ -59,8 +59,6 @@
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
 
-static void exit_mm(struct task_struct *tsk);
