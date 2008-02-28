From: akpm@linux-foundation.org
Subject: + ipmi-remove-unused-target-and-action-in-makefile.patch added to -mm tree
Date: Wed, 27 Feb 2008 21:45:52 -0800
Message-ID: <200802280545.m1S5jqPd018088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbYB1FqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 00:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, minyard@acm.org, sam@ravnborg.org


The patch titled
     ipmi: remove unused target and action in Makefile
has been added to the -mm tree.  Its filename is
     ipmi-remove-unused-target-and-action-in-makefile.patch

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
-
_

Patches currently in -mm which might be from crquan@gmail.com are

git-gfs2-nmw.patch
3w-raid-drivers-memset-not-needed-in-probe.patch
git-xfs.patch
ipmi-remove-unused-target-and-action-in-makefile.patch
