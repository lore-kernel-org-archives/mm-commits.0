From: akpm@linux-foundation.org
Subject: + maintainers-remove-section-smx-uio-interface.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:12:27 -0700
Message-ID: <201006112012.o5BKCRUD016993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758633Ab0FKUTn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:19:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bn@niasdigital.com, hjk@linutronix.de


The patch titled
     MAINTAINERS: remove section SMX UIO Interface
has been added to the -mm tree.  Its filename is
     maintainers-remove-section-smx-uio-interface.patch

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
Subject: MAINTAINERS: remove section SMX UIO Interface
From: Joe Perches <joe@perches.com>

Commit d6e976c0d258c9547a308bd8a9a82ec93e2bc6e2 ("UIO: Remove SMX
Cryptengine driver") removed the file.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Ben Nizette <bn@niasdigital.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-section-smx-uio-interface MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-section-smx-uio-interface
+++ a/MAINTAINERS
@@ -5239,11 +5239,6 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/smsc9420.*
 
-SMX UIO Interface
-M:	Ben Nizette <bn@niasdigital.com>
-S:	Maintained
-F:	drivers/uio/uio_smx.c
-
 SN-IA64 (Itanium) SUB-PLATFORM
 M:	Jes Sorensen <jes@sgi.com>
 L:	linux-altix@sgi.com
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

