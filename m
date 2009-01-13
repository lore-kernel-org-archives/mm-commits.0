From: akpm@linux-foundation.org
Subject: + acpi-kconfig-fix-acpi_container-module-name.patch added to -mm tree
Date: Tue, 13 Jan 2009 13:57:08 -0800
Message-ID: <200901132157.n0DLv8Na004372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbZAMV5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 16:57:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tvignaud@mandriva.com, lenb@kernel.org


The patch titled
     acpi Kconfig: fix ACPI_CONTAINER module name
has been added to the -mm tree.  Its filename is
     acpi-kconfig-fix-acpi_container-module-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

acpi-kconfig-fix-acpi_container-module-name.patch
kill-prehistorical-comments-about-usb_ehci_hcd.patch

