From: akpm@linux-foundation.org
Subject: + maintainers-acpi-add-include-acpi.patch added to -mm tree
Date: Sun, 13 Sep 2009 16:48:36 -0700
Message-ID: <200909132348.n8DNmaIK001482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368AbZIMXsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Sep 2009 19:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: felipe.contreras@gmail.com, joe@perches.com


The patch titled
     MAINTAINERS: acpi: add 'include/acpi'
has been added to the -mm tree.  Its filename is
     maintainers-acpi-add-include-acpi.patch

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
Subject: MAINTAINERS: acpi: add 'include/acpi'
From: Felipe Contreras <felipe.contreras@gmail.com>

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-acpi-add-include-acpi MAINTAINERS
--- a/MAINTAINERS~maintainers-acpi-add-include-acpi
+++ a/MAINTAINERS
@@ -233,6 +233,7 @@ S:	Supported
 F:	drivers/acpi/
 F:	drivers/pnp/pnpacpi/
 F:	include/linux/acpi.h
+F:	include/acpi/
 
 ACPI BATTERY DRIVERS
 M:	Alexey Starikovskiy <astarikovskiy@suse.de>
_

Patches currently in -mm which might be from felipe.contreras@gmail.com are

maintainers-acpi-add-include-acpi.patch
maintainers-omap-fix-regex.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch

