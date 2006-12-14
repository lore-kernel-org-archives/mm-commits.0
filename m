From: akpm@osdl.org
Subject: - w1-fix-for-kconfig-entry-typo.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:05:23 -0800
Message-ID: <200612140605.kBE65N9t001836@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51825 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbWLNGF5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:05:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnpol@2ka.mipt.ru, alexander.rigbo@acgnystrom.se, mm-commits@vger.kernel.org


The patch titled
     w1: Fix for kconfig entry typo
has been removed from the -mm tree.  Its filename was
     w1-fix-for-kconfig-entry-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: w1: Fix for kconfig entry typo
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Based on patch from Alexander Rigbo <alexander.rigbo@acgnystrom.se>

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/w1/slaves/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/w1/slaves/Kconfig~w1-fix-for-kconfig-entry-typo drivers/w1/slaves/Kconfig
--- a/drivers/w1/slaves/Kconfig~w1-fix-for-kconfig-entry-typo
+++ a/drivers/w1/slaves/Kconfig
@@ -9,7 +9,7 @@ config W1_SLAVE_THERM
 	tristate "Thermal family implementation"
 	depends on W1
 	help
-	  Say Y here if you want to connect 1-wire thermal sensors to you
+	  Say Y here if you want to connect 1-wire thermal sensors to your
 	  wire.
 
 config W1_SLAVE_SMEM
@@ -17,7 +17,7 @@ config W1_SLAVE_SMEM
 	depends on W1
 	help
 	  Say Y here if you want to connect 1-wire
-	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to you wire.
+	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
 
 config W1_SLAVE_DS2433
 	tristate "4kb EEPROM family support (DS2433)"
_

Patches currently in -mm which might be from johnpol@2ka.mipt.ru are

connector-some-fixes-for-ia64-unaligned-access-errors.patch

