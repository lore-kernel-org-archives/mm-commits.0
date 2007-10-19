From: akpm@linux-foundation.org
Subject: + dzh-remove-useless-unused-module-junk.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:25:51 -0700
Message-ID: <200710192125.l9JLPpdJ020925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758617AbXJSV0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:26:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jirislaby@gmail.com


The patch titled
     dz.h: remove useless unused module junk
has been added to the -mm tree.  Its filename is
     dzh-remove-useless-unused-module-junk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
kernel-printkc-concerns-about-the-console-handover.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
