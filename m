From: akpm@linux-foundation.org
Subject: + maintainers-email-update-and-add-missing-entry.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:34:18 -0800
Message-ID: <200801100633.m0A6XwWD009021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbYAJGeF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:34:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com


The patch titled
     MAINTAINERS: email update and add missing entry
has been added to the -mm tree.  Its filename is
     maintainers-email-update-and-add-missing-entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: email update and add missing entry
From: Nicolas Ferre <nicolas.ferre@atmel.com>

MAINTAINERS email update
add atmel_lcdfb entry

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-email-update-and-add-missing-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-email-update-and-add-missing-entry
+++ a/MAINTAINERS
@@ -665,12 +665,18 @@ S:	Maintained
 
 ATMEL AT91 MCI DRIVER
 P:	Nicolas Ferre
-M:	nicolas.ferre@rfo.atmel.com
+M:	nicolas.ferre@atmel.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
 
+ATMEL LCDFB DRIVER
+P:	Nicolas Ferre
+M:	nicolas.ferre@atmel.com
+L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
+S:	Maintained
+
 ATMEL MACB ETHERNET DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

maintainers-email-update-and-add-missing-entry.patch
atmel_lcdfb-email-update.patch
git-arm.patch
