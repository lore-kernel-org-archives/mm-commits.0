From: akpm@linux-foundation.org
Subject: + kconfig-improved-help-for-config_accessibility.patch added to -mm tree
Date: Thu, 01 May 2008 09:09:13 -0700
Message-ID: <200805011609.m41G9Dgx013888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156AbYEAQJn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 12:09:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org


The patch titled
     Kconfig: improved help for CONFIG_ACCESSIBILITY
has been added to the -mm tree.  Its filename is
     kconfig-improved-help-for-config_accessibility.patch

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
Subject: Kconfig: improved help for CONFIG_ACCESSIBILITY
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Add a small explanation of what accessibility is.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/accessibility/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/accessibility/Kconfig~kconfig-improved-help-for-config_accessibility drivers/accessibility/Kconfig
--- a/drivers/accessibility/Kconfig~kconfig-improved-help-for-config_accessibility
+++ a/drivers/accessibility/Kconfig
@@ -3,6 +3,13 @@ menuconfig ACCESSIBILITY
 	---help---
 	  Enable a submenu where accessibility items may be enabled.
 
+	  Accessibility handles all special kinds of hardware devices or
+	  software adapters which help people with disabilities (e.g.
+	  blindness) to use computers.
+
+	  That includes braille devices, speech synthesis, keyboard
+	  remapping, etc.
+
 	  If unsure, say N.
 
 if ACCESSIBILITY
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch
kconfig-improved-help-for-config_accessibility.patch

