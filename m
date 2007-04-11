From: akpm@linux-foundation.org
Subject: + clocksource-acpi_pm-trivial-comment-update.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:28:06 -0700
Message-ID: <200704110028.l3B0S6DC024099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53664 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932255AbXDKA2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:28:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dwalker@mvista.com


The patch titled
     clocksource: acpi_pm trivial comment update
has been added to the -mm tree.  Its filename is
     clocksource-acpi_pm-trivial-comment-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: clocksource: acpi_pm trivial comment update
From: Daniel Walker <dwalker@mvista.com>

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/clocksource/acpi_pm.c~clocksource-acpi_pm-trivial-comment-update drivers/clocksource/acpi_pm.c
--- a/drivers/clocksource/acpi_pm.c~clocksource-acpi_pm-trivial-comment-update
+++ a/drivers/clocksource/acpi_pm.c
@@ -26,7 +26,7 @@
 /*
  * The I/O port the PMTMR resides at.
  * The location is detected during setup_arch(),
- * in arch/i386/acpi/boot.c
+ * in arch/i386/kernel/acpi/boot.c
  */
 u32 pmtmr_ioport __read_mostly;
 
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-acpi_pm-trivial-comment-update.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
