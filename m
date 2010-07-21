From: akpm@linux-foundation.org
Subject: + maintainers-orphan-befs.patch added to -mm tree
Date: Wed, 21 Jul 2010 13:51:41 -0700
Message-ID: <201007212051.o6LKpf42014458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683Ab0GUUvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 16:51:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, rathamahata@gmail.com


The patch titled
     MAINTAINERS: orphan BEFS
has been added to the -mm tree.  Its filename is
     maintainers-orphan-befs.patch

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
Subject: MAINTAINERS: orphan BEFS
From: Joe Perches <joe@perches.com>

This old address bounces and Sergey doesn't answer at another email
address.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Sergey Kostyliov <rathamahata@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-orphan-befs MAINTAINERS
--- a/MAINTAINERS~maintainers-orphan-befs
+++ a/MAINTAINERS
@@ -1252,8 +1252,7 @@ S:	Maintained
 F:	drivers/net/hamradio/baycom*
 
 BEFS FILE SYSTEM
-M:	"Sergey S. Kostyliov" <rathamahata@php4.ru>
-S:	Maintained
+S:	Orphan
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
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
maintainers-update-laurent-pinchart-email.patch
maintainers-orphan-befs.patch
checkpatchpl-add-check-for-space-after-struct-or-union-definition.patch
documentation-networking-wavelantxt-deleted-not-in-tree.patch

