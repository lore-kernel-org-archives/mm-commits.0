From: akpm@linux-foundation.org
Subject: - remove-double-mention-of-support-for-acpi-option.patch removed from -mm tree
Date: Tue, 30 Oct 2007 11:06:43 -0700
Message-ID: <200710301806.l9UI6hXI020545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbXJ3SHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 14:07:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     acpi: remove double mention of Support for ACPI option
has been removed from the -mm tree.  Its filename was
     remove-double-mention-of-support-for-acpi-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
