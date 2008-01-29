From: akpm@linux-foundation.org
Subject: - iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:49:52 -0800
Message-ID: <200801290149.m0T1nqK6027529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYA2CAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 21:00:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yi.zhu@intel.com, linville@tuxdriver.com, mboton.lkml@gmail.com, mm-commits@vger.kernel.org


The patch titled
     iwlwifi: fix typo in 'drivers/net/wireless/iwlwifi/Kconfig'
has been removed from the -mm tree.  Its filename was
     iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iwlwifi: fix typo in 'drivers/net/wireless/iwlwifi/Kconfig'
From: Zhu Yi <yi.zhu@intel.com>

Based on a patch by Miguel.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Cc: Miguel Boton <mboton.lkml@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/iwlwifi/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/wireless/iwlwifi/Kconfig~iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig drivers/net/wireless/iwlwifi/Kconfig
--- a/drivers/net/wireless/iwlwifi/Kconfig~iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig
+++ a/drivers/net/wireless/iwlwifi/Kconfig
@@ -31,7 +31,7 @@ config IWL4965_QOS
 	depends on IWL4965
 	---help---
 	  This option will enable wireless quality of service (QoS) for the
-	  iw4965 driver.
+	  iwl4965 driver.
 
 config IWL4965_HT
 	bool "Enable 802.11n HT features in iwl4965 driver"
@@ -43,7 +43,7 @@ config IWL4965_HT
 	  for the iwl4965 driver.
 
 config IWL4965_SPECTRUM_MEASUREMENT
-	bool "Enable Spectrum Measurement in iw4965 driver"
+	bool "Enable Spectrum Measurement in iwl4965 driver"
 	depends on IWL4965
 	---help---
 	  This option will enable spectrum measurement for the iwl4965 driver.
_

Patches currently in -mm which might be from yi.zhu@intel.com are

git-net.patch
