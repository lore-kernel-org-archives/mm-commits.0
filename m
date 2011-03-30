From: akpm@linux-foundation.org
Subject: + maintainers-add-arm-ts78xx-setup-platform-maintainer.patch added to -mm tree
Date: Wed, 30 Mar 2011 15:17:07 -0700
Message-ID: <201103302217.p2UMH7G0014843@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932342Ab1C3WRz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 18:17:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alex@digriz.org.uk, rmk@arm.linux.org.uk


The patch titled
     MAINTAINERS: add ARM/ts78xx-setup platform maintainer
has been added to the -mm tree.  Its filename is
     maintainers-add-arm-ts78xx-setup-platform-maintainer.patch

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
Subject: MAINTAINERS: add ARM/ts78xx-setup platform maintainer
From: Alexander Clouter <alex@digriz.org.uk>

Signed-off-by: Alexander Clouter <alex@digriz.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-arm-ts78xx-setup-platform-maintainer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-arm-ts78xx-setup-platform-maintainer
+++ a/MAINTAINERS
@@ -877,6 +877,13 @@ F:	arch/arm/mach-mv78xx0/
 F:	arch/arm/mach-orion5x/
 F:	arch/arm/plat-orion/
 
+ARM/Orion SoC/Technologic Systems TS-78xx platform support
+M:	Alexander Clouter <alex@digriz.org.uk>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+W:	http://www.digriz.org.uk/ts78xx/kernel
+S:	Maintained
+F:	arch/arm/mach-orion5x/ts78xx-*
+
 ARM/MIOA701 MACHINE SUPPORT
 M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
_

Patches currently in -mm which might be from alex@digriz.org.uk are

origin.patch
maintainers-add-arm-ts78xx-setup-platform-maintainer.patch

