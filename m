From: akpm@linux-foundation.org
Subject: [merged] printk-avoid-warning-when-config_printk-is-disabled.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:42 -0800
Message-ID: <201003091906.o29J6ghO031274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab0CITWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: padovan@profusion.mobi, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     printk: avoid warning when CONFIG_PRINTK is disabled
has been removed from the -mm tree.  Its filename was
     printk-avoid-warning-when-config_printk-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: avoid warning when CONFIG_PRINTK is disabled
From: "Gustavo F. Padovan" <padovan@profusion.mobi>

kernel/printk.c:72: warning: `saved_console_loglevel' defined but not used

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/printk.c~printk-avoid-warning-when-config_printk-is-disabled kernel/printk.c
--- a/kernel/printk.c~printk-avoid-warning-when-config_printk-is-disabled
+++ a/kernel/printk.c
@@ -70,8 +70,6 @@ int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
 
-static int saved_console_loglevel = -1;
