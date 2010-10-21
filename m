From: akpm@linux-foundation.org
Subject: + drivers-char-ipmi-makefile-replace-the-use-of-module-objs-with-module-y.patch added to -mm tree
Date: Thu, 21 Oct 2010 15:25:48 -0700
Message-ID: <201010212225.o9LMPmas007265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758859Ab0JUW0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 18:26:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tdent48227@gmail.com, jirislaby@gmail.com, minyard@acm.org, mmarek@suse.cz


The patch titled
     drivers/char/ipmi/Makefile: replace the use of <module>-objs with <module>-y
has been added to the -mm tree.  Its filename is
     drivers-char-ipmi-makefile-replace-the-use-of-module-objs-with-module-y.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/ipmi/Makefile: replace the use of <module>-objs with <module>-y
From: Tracey Dent <tdent48227@gmail.com>

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/Makefile~drivers-char-ipmi-makefile-replace-the-use-of-module-objs-with-module-y drivers/char/ipmi/Makefile
--- a/drivers/char/ipmi/Makefile~drivers-char-ipmi-makefile-replace-the-use-of-module-objs-with-module-y
+++ a/drivers/char/ipmi/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the ipmi drivers.
 #
 
-ipmi_si-objs := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o
+ipmi_si-y := ipmi_si_intf.o ipmi_kcs_sm.o ipmi_smic_sm.o ipmi_bt_sm.o
 
 obj-$(CONFIG_IPMI_HANDLER) += ipmi_msghandler.o
 obj-$(CONFIG_IPMI_DEVICE_INTERFACE) += ipmi_devintf.o
_

Patches currently in -mm which might be from tdent48227@gmail.com are

linux-next.patch
drivers-char-ip2-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-ipmi-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-mwave-makefile-clean-up.patch
drivers-char-pcmcia-ipwireless-makefile-makefile-replace-the-use-of-module-objs-with-module-y.patch
drivers-char-rio-makefile-replace-the-use-of-module-objs-with-module-y.patch

