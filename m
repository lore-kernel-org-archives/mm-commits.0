From: akpm@linux-foundation.org
Subject: + sc26xx-missing-port-define-in-serial_coreh.patch added to -mm tree
Date: Mon, 11 Feb 2008 13:07:31 -0800
Message-ID: <200802112107.m1BL7VtF000459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49077 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYBKVMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 16:12:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tsbogend@alpha.franken.de


The patch titled
     SC26XX: missing PORT define in serial_core.h
has been added to the -mm tree.  Its filename is
     sc26xx-missing-port-define-in-serial_coreh.patch

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
Subject: SC26XX: missing PORT define in serial_core.h
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

When submitting the driver for inclusion to 2.6.25 I've missed the change to
serial_core.h. This patch fixes this.

Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/serial_core.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/serial_core.h~sc26xx-missing-port-define-in-serial_coreh include/linux/serial_core.h
--- a/include/linux/serial_core.h~sc26xx-missing-port-define-in-serial_coreh
+++ a/include/linux/serial_core.h
@@ -149,6 +149,8 @@
 /* Freescale ColdFire */
 #define PORT_MCF	78
 
+#define PORT_SC26XX	79
+
 
 /* MN10300 on-chip UART numbers */
 #define PORT_MN10300		80
_

Patches currently in -mm which might be from tsbogend@alpha.franken.de are

origin.patch
sc26xx-missing-port-define-in-serial_coreh.patch
git-watchdog.patch
