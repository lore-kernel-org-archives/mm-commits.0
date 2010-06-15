From: akpm@linux-foundation.org
Subject: + maintainers-add-patterns-to-wimax-stack.patch added to -mm tree
Date: Tue, 15 Jun 2010 13:14:26 -0700
Message-ID: <201006152014.o5FKEQFZ028287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757958Ab0FOUO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jun 2010 16:14:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, inaky.perez-gonzalez@intel.com


The patch titled
     MAINTAINERS: add patterns to WIMAX STACK
has been added to the -mm tree.  Its filename is
     maintainers-add-patterns-to-wimax-stack.patch

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
Subject: MAINTAINERS: add patterns to WIMAX STACK
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~maintainers-add-patterns-to-wimax-stack MAINTAINERS
--- a/MAINTAINERS~maintainers-add-patterns-to-wimax-stack
+++ a/MAINTAINERS
@@ -6280,6 +6280,11 @@ M:	linux-wimax@intel.com
 L:	wimax@linuxwimax.org
 S:	Supported
 W:	http://linuxwimax.org
+F:	Documentation/wimax/README.wimax
+F:	include/linux/wimax.h
+F:	include/linux/wimax/debug.h
+F:	include/net/wimax.h
+F:	net/wimax/
 
 WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM
 M:	David Vrabel <david.vrabel@csr.com>
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
maintainers-add-file-patterns-to-uclinux-for-renesas-h8-300.patch
maintainers-update-drm-drivers-patterns.patch
maintainers-add-patterns-to-cryptographic-random-number-generator.patch
maintainers-add-patterns-to-dell-wmi-extras.patch
maintainers-add-patterns-to-powerpc-embedded-ppc8xx.patch
maintainers-add-patterns-to-omap-usb.patch
maintainers-remove-section-promise-dc4030.patch
maintainers-add-patterns-to-ps3vram-driver.patch
maintainers-add-patterns-to-wimax-stack.patch
documentation-networking-wavelantxt-deleted-not-in-tree.patch

