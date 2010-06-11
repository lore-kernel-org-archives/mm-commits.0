From: akpm@linux-foundation.org
Subject: + maintainers-add-file-patterns-to-uclinux-for-renesas-h8-300.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:18:40 -0700
Message-ID: <201006112018.o5BKIeAX017349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760250Ab0FKUS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, ysato@users.sourceforge.jp


The patch titled
     MAINTAINERS: add file patterns to UCLINUX FOR RENESAS H8/300
has been added to the -mm tree.  Its filename is
     maintainers-add-file-patterns-to-uclinux-for-renesas-h8-300.patch

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
Subject: MAINTAINERS: add file patterns to UCLINUX FOR RENESAS H8/300
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +++
 1 file changed, 3 insertions(+)

diff -puN MAINTAINERS~maintainers-add-file-patterns-to-uclinux-for-renesas-h8-300 MAINTAINERS
--- a/MAINTAINERS~maintainers-add-file-patterns-to-uclinux-for-renesas-h8-300
+++ a/MAINTAINERS
@@ -5718,6 +5718,9 @@ UCLINUX FOR RENESAS H8/300 (H8300)
 M:	Yoshinori Sato <ysato@users.sourceforge.jp>
 W:	http://uclinux-h8.sourceforge.jp/
 S:	Supported
+F:	arch/h8300/
+F:	drivers/ide/ide-h8300.c
+F:	drivers/net/ne-h8300.c
 
 UDF FILESYSTEM
 M:	Jan Kara <jack@suse.cz>
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
documentation-networking-wavelantxt-deleted-not-in-tree.patch

