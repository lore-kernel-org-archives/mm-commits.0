From: akpm@linux-foundation.org
Subject: + remove-double-mention-of-support-for-acpi-option.patch added to -mm tree
Date: Mon, 29 Oct 2007 13:50:00 -0700
Message-ID: <200710292050.l9TKo05k022628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54463 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbXJ2Uur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: elendil@planet.nl, lenb@kernel.org


The patch titled
     acpi: remove double mention of Support for ACPI option
has been added to the -mm tree.  Its filename is
     remove-double-mention-of-support-for-acpi-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: remove double mention of Support for ACPI option
From: Frans Pop <elendil@planet.nl>

Current description for CONFIG_ACPI includes the word "Support" twice.  One
effect of this is that in menuconfig the "--->" that indicates the presence
of sub-options will not show up unless you have a very wide console.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/Kconfig~remove-double-mention-of-support-for-acpi-option drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig~remove-double-mention-of-support-for-acpi-option
+++ a/drivers/acpi/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig ACPI
-	bool "ACPI Support (Advanced Configuration and Power Interface) Support"
+	bool "ACPI (Advanced Configuration and Power Interface) Support"
 	depends on !X86_NUMAQ
 	depends on !X86_VISWS
 	depends on !IA64_HP_SIM
_

Patches currently in -mm which might be from elendil@planet.nl are

remove-double-mention-of-support-for-acpi-option.patch
acpi-use-select-power_supply-for-ac-battery-and-sbs.patch
