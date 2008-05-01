From: akpm@linux-foundation.org
Subject: + kconfig-improved-help-for-config_accessibility-fix.patch added to -mm tree
Date: Thu, 01 May 2008 12:28:27 -0700
Message-ID: <200805011928.m41JSR7A021412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765486AbYEAT3n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 15:29:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org


The patch titled
     kconfig-improved-help-for-config_accessibility fix
has been added to the -mm tree.  Its filename is
     kconfig-improved-help-for-config_accessibility-fix.patch

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
Subject: kconfig-improved-help-for-config_accessibility fix
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Indicate that enabling just CONFIG_ACCESSIBILITY does not add code.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/accessibility/Kconfig |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/accessibility/Kconfig~kconfig-improved-help-for-config_accessibility-fix drivers/accessibility/Kconfig
--- a/drivers/accessibility/Kconfig~kconfig-improved-help-for-config_accessibility-fix
+++ a/drivers/accessibility/Kconfig
@@ -1,8 +1,6 @@
 menuconfig ACCESSIBILITY
 	bool "Accessibility support"
 	---help---
-	  Enable a submenu where accessibility items may be enabled.
