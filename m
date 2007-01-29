From: akpm@osdl.org
Subject: - pnpacpi-remove-experimental-dependency.patch removed from -mm tree
Date: Mon, 29 Jan 2007 13:17:21 -0800
Message-ID: <200701292117.l0TLHL7v031180@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57305 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbXA2VSy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 16:18:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     PNPACPI: remove EXPERIMENTAL dependency
has been removed from the -mm tree.  Its filename was
     pnpacpi-remove-experimental-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNPACPI: remove EXPERIMENTAL dependency
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

PNPACPI is pretty widely used and seems fairly stable, so remove the
dependency on EXPERIMENTAL.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pnp/pnpacpi/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pnp/pnpacpi/Kconfig~pnpacpi-remove-experimental-dependency drivers/pnp/pnpacpi/Kconfig
--- a/drivers/pnp/pnpacpi/Kconfig~pnpacpi-remove-experimental-dependency
+++ a/drivers/pnp/pnpacpi/Kconfig
@@ -2,8 +2,8 @@
 # Plug and Play ACPI configuration
 #
 config PNPACPI
-	bool "Plug and Play ACPI support (EXPERIMENTAL)"
-	depends on PNP && ACPI && EXPERIMENTAL
+	bool "Plug and Play ACPI support"
+	depends on PNP && ACPI
 	default y
 	---help---
 	  Linux uses the PNPACPI to autodetect built-in
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

git-acpi.patch
acpi-updates-rtc-cmos-device-platform_data.patch
2.6-sony_acpi4.patch
serial-trivial-code-flow-simplification.patch
