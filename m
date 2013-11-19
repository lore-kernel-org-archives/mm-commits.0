From: akpm@linux-foundation.org
Subject: +
 maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch added
 to -mm tree
Date: Tue, 19 Nov 2013 15:48:29 -0800
Message-ID: <528bf8cd.p1MztFsDdOGp7OTx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3KSXsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 18:48:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hch@lst.de, alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org

Subject: + maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch added to -mm tree
To: geert@linux-m68k.org,alan@lxorguk.ukuu.org.uk,hch@lst.de
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 15:48:29 -0800


The patch titled
     Subject: MAINTAINERS: add an entry for the Macintosh HFSPlus Filesystem
has been added to the -mm tree.  Its filename is
     maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: MAINTAINERS: add an entry for the Macintosh HFSPlus Filesystem

To make scripts/get_maintainer.pl output something sensible.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem MAINTAINERS
--- a/MAINTAINERS~maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem
+++ a/MAINTAINERS
@@ -3937,6 +3937,12 @@ S:	Orphan
 F:	Documentation/filesystems/hfs.txt
 F:	fs/hfs/
 
+HFSPLUS FILESYSTEM
+L:	linux-fsdevel@vger.kernel.org
+S:	Orphan
+F:	Documentation/filesystems/hfsplus.txt
+F:	fs/hfsplus/
+
 HGA FRAMEBUFFER DRIVER
 M:	Ferenc Bakonyi <fero@drama.obuda.kando.hu>
 L:	linux-nvidia@lists.surfsouth.com
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
drivers-rtc-rtc-s5mc-fix-info-rtc-assignment.patch
drivers-gpu-drm-drm_edid_loadc-make-edid_load-return-a-void.patch
genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
asm-typesh-remove-include-asm-generic-int-l64h.patch
maintainers-add-an-entry-for-the-macintosh-hfsplus-filesystem.patch
linux-next.patch

