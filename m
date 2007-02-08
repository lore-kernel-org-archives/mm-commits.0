From: akpm@linux-foundation.org
Subject: - acpi-make-bay-depend-on-dock.patch removed from -mm tree
Date: Wed, 07 Feb 2007 16:13:27 -0800
Message-ID: <200702080013.l180DSDE032227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47144 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161358AbXBHANa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 19:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: Make bay depend on dock
has been removed from the -mm tree.  Its filename was
     acpi-make-bay-depend-on-dock.patch

This patch was dropped because recursive dependency?

------------------------------------------------------
Subject: ACPI: Make bay depend on dock
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since the bay driver depends on the dock driver for proper notification, make
this driver depend on the dock driver.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/acpi/Kconfig~acpi-make-bay-depend-on-dock drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-make-bay-depend-on-dock
+++ a/drivers/acpi/Kconfig
@@ -151,6 +151,7 @@ config ACPI_FAN
 config ACPI_DOCK
 	tristate "Dock"
 	depends on EXPERIMENTAL
+	depends on ACPI_DOCK
 	help
 	  This driver adds support for ACPI controlled docking stations
 
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

git-acpi.patch
acpi-bay-remove-acpi-driver-struct.patch
acpi-make-bay-depend-on-dock.patch
git-libata-all.patch
