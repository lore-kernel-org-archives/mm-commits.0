From: akpm@linux-foundation.org
Subject: + maintainers-update-drm-drivers-patterns.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:31:33 -0700
Message-ID: <201006112031.o5BKVXd4017926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757815Ab0FKUcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:32:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, airlied@linux.ie


The patch titled
     MAINTAINERS: update DRM DRIVERS patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-drm-drivers-patterns.patch

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
Subject: MAINTAINERS: update DRM DRIVERS patterns
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-update-drm-drivers-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-drm-drivers-patterns
+++ a/MAINTAINERS
@@ -2005,6 +2005,7 @@ L:	dri-devel@lists.freedesktop.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/gpu/drm/
+F:	include/drm/
 
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
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
documentation-networking-wavelantxt-deleted-not-in-tree.patch

