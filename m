From: akpm@linux-foundation.org
Subject: - acpi-make-bay-depend-on-dock.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:55 -0800
Message-ID: <200703020506.l2256t7Y000838@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42445 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422770AbXCBFIJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:08:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristen.c.accardi@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: make bay depend on dock
has been removed from the -mm tree.  Its filename was
     acpi-make-bay-depend-on-dock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: make bay depend on dock
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since the bay driver depends on the dock driver for proper notification,
make this driver depend on the dock driver.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Acked-by: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/Kconfig~acpi-make-bay-depend-on-dock drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-make-bay-depend-on-dock
+++ a/drivers/acpi/Kconfig
@@ -149,6 +149,7 @@ config ACPI_DOCK
 config ACPI_BAY
 	tristate "Removable Drive Bay (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	depends on ACPI_DOCK
 	help
 	  This driver adds support for ACPI controlled removable drive
 	  bays such as the IBM ultrabay or the Dell Module Bay.
_

Patches currently in -mm which might be from kristen.c.accardi@intel.com are

origin.patch
