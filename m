From: akpm@linux-foundation.org
Subject: + maintainers-update-atmel-at91-entry.patch added to -mm tree
Date: Wed, 19 Jan 2011 15:57:19 -0800
Message-ID: <201101192357.p0JNvJCu011262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab1ASX5i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 18:57:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, linux@maxim.org.za, plagnioj@jcrosoft.com, rmk@arm.linux.org.uk


The patch titled
     MAINTAINERS: update Atmel AT91 entry
has been added to the -mm tree.  Its filename is
     maintainers-update-atmel-at91-entry.patch

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
Subject: MAINTAINERS: update Atmel AT91 entry
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Add two co-maintainers and update the entry with new information.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Andrew Victor <linux@maxim.org.za>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-update-atmel-at91-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-update-atmel-at91-entry
+++ a/MAINTAINERS
@@ -624,11 +624,15 @@ M:	Lennert Buytenhek <kernel@wantstofly.
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
-ARM/ATMEL AT91RM9200 ARM ARCHITECTURE
+ARM/ATMEL AT91RM9200 AND AT91SAM ARM ARCHITECTURES
 M:	Andrew Victor <linux@maxim.org.za>
+M:	Nicolas Ferre <nicolas.ferre@atmel.com>
+M:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://maxim.org.za/at91_26.html
-S:	Maintained
+W:	http://www.linux4sam.org
+S:	Supported
+F:	arch/arm/mach-at91/
 
 ARM/BCMRING ARM ARCHITECTURE
 M:	Jiandong Zheng <jdzheng@broadcom.com>
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

maintainers-update-atmel-at91-entry.patch

