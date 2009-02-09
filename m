From: akpm@linux-foundation.org
Subject: [merged] acpi-kconfig-fix-acpi_container-module-name.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:05:22 -0800
Message-ID: <200902092005.n19K5Mid024364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbZBIUKM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:10:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tvignaud@mandriva.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi Kconfig: fix ACPI_CONTAINER module name
has been removed from the -mm tree.  Its filename was
     acpi-kconfig-fix-acpi_container-module-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi Kconfig: fix ACPI_CONTAINER module name
From: Thierry Vignaud <tvignaud@mandriva.com>

Fix the ACPI_CONTAINER module name according to the real module name.

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/Kconfig~acpi-kconfig-fix-acpi_container-module-name drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-kconfig-fix-acpi_container-module-name
+++ a/drivers/acpi/Kconfig
@@ -287,7 +287,7 @@ config ACPI_CONTAINER
 	  support physical cpu/memory hot-plug.
 
 	  If one selects "m", this driver can be loaded with
-	  "modprobe acpi_container".
+	  "modprobe container".
 
 config ACPI_HOTPLUG_MEMORY
 	tristate "Memory Hotplug"
_

Patches currently in -mm which might be from tvignaud@mandriva.com are

usb-kill-prehistorical-comments-about-usb_ehci_hcd.patch

