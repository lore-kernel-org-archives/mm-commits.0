From: akpm@linux-foundation.org
Subject: - swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:25:10 -0700
Message-ID: <200807242325.m6ONPAZe010855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbYGXXZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     swsusp: provide users with a hint about the no_console_suspend option
has been removed from the -mm tree.  Its filename was
     swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swsusp: provide users with a hint about the no_console_suspend option
From: Pavel Machek <pavel@suse.cz>

Tell the user about the no_console_suspend option, so that we don't have to
tell each bug reporter personally.

[akpm@linux-foundation.org: clarify the text a little]
Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option kernel/printk.c
--- a/kernel/printk.c~swsusp-provide-users-with-a-hint-about-the-no_console_suspend-option
+++ a/kernel/printk.c
@@ -933,7 +933,7 @@ void suspend_console(void)
 {
 	if (!console_suspend_enabled)
 		return;
-	printk("Suspending console(s)\n");
+	printk("Suspending console(s) (use no_console_suspend to debug)\n");
 	acquire_console_sem();
 	console_suspended = 1;
 }
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
linux-next.patch

