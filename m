From: akpm@linux-foundation.org
Subject: + ipmi-update-driver-version.patch added to -mm tree
Date: Wed, 13 Feb 2008 15:29:14 -0800
Message-ID: <200802132329.m1DNTEoL019596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35006 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759080AbYBMX3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 18:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cminyard@mvista.com


The patch titled
     ipmi: update driver version
has been added to the -mm tree.  Its filename is
     ipmi-update-driver-version.patch

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
Subject: ipmi: update driver version
From: Corey Minyard <cminyard@mvista.com>

Enough bug fixes and changes that we need a new driver version.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-update-driver-version drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-update-driver-version
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -47,7 +47,7 @@
 
 #define PFX "IPMI message handler: "
 
-#define IPMI_DRIVER_VERSION "39.1"
+#define IPMI_DRIVER_VERSION "39.2"
 
 static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
 static int ipmi_init_msghandler(void);
_

Patches currently in -mm which might be from cminyard@mvista.com are

git-watchdog.patch
ipmi-hold-attn-until-upper-layer-ready.patch
ipmi-change-device-node-ordering-to-reflect-probe-order.patch
ipmi-run-to-completion-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-dont-grab-locks-in-run-to-completion-mode.patch
ipmi-dont-print-event-queue-full-on-every-event.patch
ipmi-update-driver-version.patch
ipmi-convert-locked-counters-to-atomics.patch
ipmi-convert-locked-counters-to-atomics-in-the-system-interface.patch
