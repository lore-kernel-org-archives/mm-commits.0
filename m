From: akpm@linux-foundation.org
Subject: [folded-merged] exit_thread-remove-empty-bodies-fix.patch removed from -mm tree
Date: Fri, 20 May 2016 16:43:47 -0700
Message-ID: <573fa133.p8bV4VRgcNcBz3bY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbcETXnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:43:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jslaby@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: exit_thread-remove-empty-bodies-fix
has been removed from the -mm tree.  Its filename was
     exit_thread-remove-empty-bodies-fix.patch

This patch was dropped because it was folded into exit_thread-remove-empty-bodies.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: exit_thread-remove-empty-bodies-fix

fix mips

Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/process.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/mips/kernel/process.c~exit_thread-remove-empty-bodies-fix arch/mips/kernel/process.c
--- a/arch/mips/kernel/process.c~exit_thread-remove-empty-bodies-fix
+++ a/arch/mips/kernel/process.c
@@ -73,10 +73,6 @@ void start_thread(struct pt_regs * regs,
 	regs->regs[29] = sp;
 }
 
-void exit_thread(void)
-{
-}
