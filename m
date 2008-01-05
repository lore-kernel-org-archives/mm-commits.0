From: akpm@linux-foundation.org
Subject: + iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig.patch added to -mm tree
Date: Fri, 04 Jan 2008 22:53:11 -0800
Message-ID: <200801050653.m056rvrM032609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59695 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbYAEG4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jan 2008 01:56:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yi.zhu@intel.com, linville@tuxdriver.com, mboton.lkml@gmail.com


The patch titled
     iwlwifi: fix typo in 'drivers/net/wireless/iwlwifi/Kconfig'
has been added to the -mm tree.  Its filename is
     iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-netdev-all.patch
iwlwifi-fix-typo-in-drivers-net-wireless-iwlwifi-kconfig.patch
