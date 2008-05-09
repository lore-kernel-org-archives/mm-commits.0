From: akpm@linux-foundation.org
Subject: - kconfig-improved-help-for-config_accessibility.patch removed from -mm tree
Date: Fri, 09 May 2008 14:46:11 -0700
Message-ID: <200805092146.m49LkBO5027084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755342AbYEIVrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 17:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     Kconfig: improved help for CONFIG_ACCESSIBILITY
has been removed from the -mm tree.  Its filename was
     kconfig-improved-help-for-config_accessibility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Kconfig: improved help for CONFIG_ACCESSIBILITY
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Add a small explanation of what accessibility is.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/accessibility/Kconfig |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/accessibility/Kconfig~kconfig-improved-help-for-config_accessibility drivers/accessibility/Kconfig
--- a/drivers/accessibility/Kconfig~kconfig-improved-help-for-config_accessibility
+++ a/drivers/accessibility/Kconfig
@@ -1,7 +1,17 @@
 menuconfig ACCESSIBILITY
 	bool "Accessibility support"
 	---help---
-	  Enable a submenu where accessibility items may be enabled.
+	  Accessibility handles all special kinds of hardware devices or
+	  software adapters which help people with disabilities (e.g.
+	  blindness) to use computers.
+
+	  That includes braille devices, speech synthesis, keyboard
+	  remapping, etc.
+
+	  Say Y here to get to see options for accessibility.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
 
 	  If unsure, say N.
 
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch

