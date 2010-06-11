From: akpm@linux-foundation.org
Subject: + maintainers-update-ppp-over-l2tp-file-patterns.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:12:23 -0700
Message-ID: <201006112012.o5BKCNYV016986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757600Ab0FKUNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jchapman@katalix.com


The patch titled
     MAINTAINERS: update PPP OVER L2TP file patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-ppp-over-l2tp-file-patterns.patch

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
Subject: MAINTAINERS: update PPP OVER L2TP file patterns
From: Joe Perches <joe@perches.com>

Commit 21b4aaa14329db793832e865f15000c5c0192ac3 ("l2tp: Relocate pppol2tp
driver to new net/l2tp directory") moved the file.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: James Chapman <jchapman@katalix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-ppp-over-l2tp-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-ppp-over-l2tp-file-patterns
+++ a/MAINTAINERS
@@ -4508,7 +4508,7 @@ F:	drivers/net/pppox.c
 PPP OVER L2TP
 M:	James Chapman <jchapman@katalix.com>
 S:	Maintained
-F:	drivers/net/pppol2tp.c
+F:	net/l2tp/l2tp_ppp.c
 F:	include/linux/if_pppol2tp.h
 
 PPS SUPPORT
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

