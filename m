From: akpm@linux-foundation.org
Subject: + mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:49:28 -0800
Message-ID: <200802142249.m1EMnSwr007113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933685AbYBNWuW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 17:50:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dwmw2@infradead.org


The patch titled
     mtd maps: document MTD_PHYSMAP module name in kconfig
has been added to the -mm tree.  Its filename is
     mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mtd maps: document MTD_PHYSMAP module name in kconfig
From: Mike Frysinger <vapier@gentoo.org>

Help out users by telling them the module name in the Kconfig help when
using the MTD_PHYSMAP option.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/maps/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/mtd/maps/Kconfig~mtd-maps-document-mtd_physmap-module-name-in-kconfig drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig~mtd-maps-document-mtd_physmap-module-name-in-kconfig
+++ a/drivers/mtd/maps/Kconfig
@@ -21,6 +21,9 @@ config MTD_PHYSMAP
 	  particular board as well as the bus width, either statically
 	  with config options or at run-time.
 
+	  To compile this driver as a module, choose M here: the
+	  module will be called physmap.
+
 config MTD_PHYSMAP_START
 	hex "Physical start address of flash mapping"
 	depends on MTD_PHYSMAP
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
flat-binaries-drop-binfmt_flat-bad-header-magic-warning.patch
mtd-maps-document-mtd_physmap-module-name-in-kconfig.patch
