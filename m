From: akpm@linux-foundation.org
Subject: - kconfig-improved-help-for-config_accessibility-fix.patch removed from -mm tree
Date: Tue, 06 May 2008 20:41:04 -0700
Message-ID: <200805070341.m473f4OS009596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756237AbYEGDla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 23:41:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     kconfig-improved-help-for-config_accessibility fix
has been removed from the -mm tree.  Its filename was
     kconfig-improved-help-for-config_accessibility-fix.patch

This patch was dropped because it was folded into kconfig-improved-help-for-config_accessibility.patch

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
