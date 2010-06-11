From: akpm@linux-foundation.org
Subject: + maintainers-update-spear-clock-framework-support-file-patterns.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:12:30 -0700
Message-ID: <201006112012.o5BKCUHJ017000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759028Ab0FKUTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, viresh.kumar@st.com


The patch titled
     MAINTAINERS: update SPEAR CLOCK FRAMEWORK SUPPORT file patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-spear-clock-framework-support-file-patterns.patch

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
Subject: MAINTAINERS: update SPEAR CLOCK FRAMEWORK SUPPORT file patterns
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-spear-clock-framework-support-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-spear-clock-framework-support-file-patterns
+++ a/MAINTAINERS
@@ -5367,7 +5367,8 @@ S:	Maintained
 F:	arch/arm/mach-spear*/clock.c
 F:	arch/arm/mach-spear*/include/mach/clkdev.h
 F:	arch/arm/plat-spear/clock.c
-F:	arch/arm/plat-spear/include/plat/clock.h and clkdev.h
+F:	arch/arm/plat-spear/include/plat/clkdev.h
+F:	arch/arm/plat-spear/include/plat/clock.h
 
 SPEAR PAD MULTIPLEXING SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
kernelh-remove-unused-nipquad-and-nipquad_fmt.patch
maintainers-update-arm-bcmring-mtd-nand-driver-file-patterns.patch
maintainers-update-arm-nuvoton-w90x900-arm-architecture-file-patterns.patch
maintainers-update-arm-voipac-pxa270-file-patterns.patch
maintainers-update-arm-zipit-z2-support-file-patterns.patch
maintainers-update-networking-file-patterns.patch
maintainers-update-ppp-over-l2tp-file-patterns.patch
maintainers-update-ricoh-smartmedia-xd-driver-file-patterns.patch
maintainers-remove-section-smx-uio-interface.patch
maintainers-update-spear-clock-framework-support-file-patterns.patch
maintainers-remove-section-strip.patch
maintainers-remove-section-wavelan-network-driver-wireless-extensions.patch
documentation-networking-wavelantxt-deleted-not-in-tree.patch

