From: akpm@linux-foundation.org
Subject: - ipmi-remove-unused-target-and-action-in-makefile.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:44:57 -0700
Message-ID: <200804300544.m3U5ivm1029455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759004AbYD3GMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, minyard@acm.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     ipmi: remove unused target and action in Makefile
has been removed from the -mm tree.  Its filename was
     ipmi-remove-unused-target-and-action-in-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: remove unused target and action in Makefile
From: Denis Cheng <crquan@gmail.com>

Kbuild system handles this automatically.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/Makefile |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/char/ipmi/Makefile~ipmi-remove-unused-target-and-action-in-makefile drivers/char/ipmi/Makefile
--- a/drivers/char/ipmi/Makefile~ipmi-remove-unused-target-and-action-in-makefile
+++ a/drivers/char/ipmi/Makefile
@@ -9,7 +9,3 @@ obj-$(CONFIG_IPMI_DEVICE_INTERFACE) += i
 obj-$(CONFIG_IPMI_SI) += ipmi_si.o
 obj-$(CONFIG_IPMI_WATCHDOG) += ipmi_watchdog.o
 obj-$(CONFIG_IPMI_POWEROFF) += ipmi_poweroff.o
-
-ipmi_si.o:	$(ipmi_si-objs)
-	$(LD) -r -o $@ $(ipmi_si-objs)
