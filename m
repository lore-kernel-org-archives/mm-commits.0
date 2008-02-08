From: akpm@linux-foundation.org
Subject: - dzh-remove-useless-unused-module-junk.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:06:12 -0800
Message-ID: <200802080805.m1885rvY014381@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761140AbYBHITg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     dz.h: remove useless unused module junk
has been removed from the -mm tree.  Its filename was
     dzh-remove-useless-unused-module-junk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dz.h: remove useless unused module junk
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Remove unused module function prototypes that would not even build if enabled.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/dz.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/serial/dz.h~dzh-remove-useless-unused-module-junk drivers/serial/dz.h
--- a/drivers/serial/dz.h~dzh-remove-useless-unused-module-junk
+++ a/drivers/serial/dz.h
@@ -124,9 +124,4 @@
 #define DZ_XMIT_SIZE   4096                 /* buffer size */
 #define DZ_WAKEUP_CHARS   DZ_XMIT_SIZE/4
 
-#ifdef MODULE
-int init_module (void)
-void cleanup_module (void)
-#endif
-
 #endif /* DZ_SERIAL_H */
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
