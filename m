From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh.patch removed from -mm tree
Date: Tue, 26 Apr 2011 11:37:36 -0700
Message-ID: <201104261832.p3QIWYJG011022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756Ab1DZSct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 14:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dilinger@queued.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/olpc_dcon/olpc_dcon_xo_1.c needs delay.h
has been removed from the -mm tree.  Its filename was
     drivers-staging-olpc_dcon-olpc_dcon_xo_1c-needs-delayh.patch

This patch was dropped because an alternative patch was merged

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
 #include <linux/delay.h>
 #include <asm/olpc.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
uml-fix-hppfs-build.patch
drivers-leds-leds-pca9532c-add-gpio-capability.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

