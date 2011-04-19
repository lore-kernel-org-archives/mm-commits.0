From: akpm@linux-foundation.org
Subject: + drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh.patch added to -mm tree
Date: Tue, 19 Apr 2011 14:37:57 -0700
Message-ID: <201104192137.p3JLbvHR026505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382Ab1DSViE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Apr 2011 17:38:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dilinger@queued.net, greg@kroah.com


The patch titled
     drivers/staging/olpc_dcon/olpc_dcon_xo_1.c needs delay.h
has been added to the -mm tree.  Its filename is
     drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh.patch

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
Subject: drivers/staging/olpc_dcon/olpc_dcon_xo_1.c needs delay.h
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error, needs delay.h:

drivers/staging/olpc_dcon/olpc_dcon_xo_1.c:168: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andres Salomon <dilinger@queued.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/staging/olpc_dcon/olpc_dcon_xo_1.c~drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c~drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh
+++ a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -11,6 +11,7 @@
  * License as published by the Free Software Foundation.
  */
 #include <linux/cs5535.h>
+#include <linux/delay.h>
 #include <linux/gpio.h>
 #include <asm/olpc.h>
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

