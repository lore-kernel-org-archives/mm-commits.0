From: akpm@linux-foundation.org
Subject: [merged] misc-dell-laptop-should-depend-on-power_supply.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:37:36 -0800
Message-ID: <200902061937.n16JbaFS011020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230AbZBFTkp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:40:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, lenb@kernel.org, mingo@elte.hu, mjg@redhat.com, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     misc: dell-laptop should depend on POWER_SUPPLY
has been removed from the -mm tree.  Its filename was
     misc-dell-laptop-should-depend-on-power_supply.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc: dell-laptop should depend on POWER_SUPPLY
From: Matthew Garrett <mjg59@srcf.ucam.org>

dell-laptop makes use of the power supply class information to choose
which backlight interface to change. Add a depends on it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/Kconfig~misc-dell-laptop-should-depend-on-power_supply drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~misc-dell-laptop-should-depend-on-power_supply
+++ a/drivers/misc/Kconfig
@@ -217,6 +217,7 @@ config DELL_LAPTOP
 	depends on EXPERIMENTAL
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL
+	depends on POWER_SUPPLY
 	default n
 	---help---
 	This driver adds support for rfkill and backlight control to Dell
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

origin.patch
linux-next.patch

