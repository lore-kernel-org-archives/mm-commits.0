From: akpm@linux-foundation.org
Subject: - mm-only-enforce-acpi-resource-conflict-checks.patch removed from -mm tree
Date: Fri, 15 Feb 2008 16:51:50 -0800
Message-ID: <200802160100.m1G10qoh001305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932334AbYBPBBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 20:01:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, bjorn.helgaas@hp.com, lenb@kernel.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     Enforce ACPI resource conflict checks
has been removed from the -mm tree.  Its filename was
     mm-only-enforce-acpi-resource-conflict-checks.patch

This patch was dropped because it is now causing warnings

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Enforce ACPI resource conflict checks
From: Jean Delvare <khali@linux-fr.org>

In -mm, enforce ACPI resource conflict checks, so that users will report
to us.

This patch is NOT meant to go to Linus at this point.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/osl.c~mm-only-enforce-acpi-resource-conflict-checks drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~mm-only-enforce-acpi-resource-conflict-checks
+++ a/drivers/acpi/osl.c
@@ -1183,7 +1183,7 @@ __setup("acpi_wake_gpes_always_on", acpi
 #define ENFORCE_RESOURCES_LAX    1
 #define ENFORCE_RESOURCES_NO     0
 
-static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
+static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
 
 static int __init acpi_enforce_resources_setup(char *str)
 {
_

Patches currently in -mm which might be from khali@linux-fr.org are

mm-only-enforce-acpi-resource-conflict-checks.patch
oz99x-i2c-button-and-led-support-driver.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
apanel-fix-kconfig-dependencies.patch
dmi-dont-save-the-same-device-twice-was-smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
dmi-prevent-linked-list-corruption-resent.patch
dmi-clean-up-dmi-helper-declarations.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
