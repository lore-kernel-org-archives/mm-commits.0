From: akpm@linux-foundation.org
Subject: + misc-dell-laptop-should-depend-on-power_supply.patch added to -mm tree
Date: Mon, 26 Jan 2009 18:38:09 -0800
Message-ID: <200901270238.n0R2c9w8029718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbZA0Ctl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 21:49:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, lenb@kernel.org, mingo@elte.hu, mjg@redhat.com, rjw@sisk.pl


The patch titled
     misc: dell-laptop should depend on POWER_SUPPLY
has been added to the -mm tree.  Its filename is
     misc-dell-laptop-should-depend-on-power_supply.patch

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

hp-wmi-fix-regressions-caused-by-missing-if-statement.patch
linux-next.patch
misc-dell-laptop-should-depend-on-power_supply.patch

