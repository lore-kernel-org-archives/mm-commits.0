From: akpm@linux-foundation.org
Subject: + maintainers-remove-section-strip.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:12:32 -0700
Message-ID: <201006112012.o5BKCWEB017004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756917Ab0FKUT2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:19:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS: remove section STRIP
has been added to the -mm tree.  Its filename is
     maintainers-remove-section-strip.patch

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
Subject: MAINTAINERS: remove section STRIP
From: Joe Perches <joe@perches.com>

Commit f80a3f62383bf673c310926d55142d51f118926d ("Staging: strip: delete
the driver") removed it.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-section-strip MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-section-strip
+++ a/MAINTAINERS
@@ -5448,11 +5448,6 @@ M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
 F:	drivers/net/starfire*
 
-STARMODE RADIO IP (STRIP) PROTOCOL DRIVER
-S:	Orphan
-F:	drivers/staging/strip/strip.c
-F:	include/linux/if_strip.h
-
 STRADIS MPEG-2 DECODER DRIVER
 M:	Nathan Laredo <laredo@gnu.org>
 W:	http://www.stradis.com/
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

