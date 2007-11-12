From: akpm@linux-foundation.org
Subject: + acpi-add-documentation-for-deprecated-proc-acpi-battery-in-acpi_procfs.patch added to -mm tree
Date: Mon, 12 Nov 2007 14:17:14 -0800
Message-ID: <200711122217.lACMHEOZ011648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755520AbXKLWRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 17:17:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ngc891@gmail.com, lenb@kernel.org


The patch titled
     ACPI: add documentation for deprecated /proc/acpi/battery in ACPI_PROCFS
has been added to the -mm tree.  Its filename is
     acpi-add-documentation-for-deprecated-proc-acpi-battery-in-acpi_procfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: add documentation for deprecated /proc/acpi/battery in ACPI_PROCFS
From: Jerome Pinot <ngc891@gmail.com>

Add documentation in Kconfig help about the move of /proc/acpi/battery to
/sys/class/power_supply when selecting ACPI_PROCFS.  This will impact a lot
of users and should be documented.

Signed-off-by: Jerome Pinot <ngc891@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/acpi/Kconfig~acpi-add-documentation-for-deprecated-proc-acpi-battery-in-acpi_procfs drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~acpi-add-documentation-for-deprecated-proc-acpi-battery-in-acpi_procfs
+++ a/drivers/acpi/Kconfig
@@ -61,6 +61,7 @@ config ACPI_PROCFS
 	  /proc/acpi/info (/sys/modules/acpi/parameters/acpica_version)
 	  /proc/acpi/dsdt (/sys/firmware/acpi/tables/DSDT)
 	  /proc/acpi/fadt (/sys/firmware/acpi/tables/FACP)
+	  /proc/acpi/battery (/sys/class/power_supply)
 	  /proc/acpi/debug_layer (/sys/module/acpi/parameters/debug_layer)
 	  /proc/acpi/debug_level (/sys/module/acpi/parameters/debug_level)
 
_

Patches currently in -mm which might be from ngc891@gmail.com are

acpi-add-documentation-for-deprecated-proc-acpi-battery-in-acpi_procfs.patch
