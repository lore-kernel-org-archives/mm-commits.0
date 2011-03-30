From: akpm@linux-foundation.org
Subject: + maintainers-update-various-tty-patterns.patch added to -mm tree
Date: Wed, 30 Mar 2011 15:36:51 -0700
Message-ID: <201103302236.p2UMapcu016324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637Ab1C3Wh2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 18:37:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, gregkh@suse.de


The patch titled
     MAINTAINERS: update various tty patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-various-tty-patterns.patch

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
Subject: MAINTAINERS: update various tty patterns
From: Joe Perches <joe@perches.com>

Commits 4a6514e6d0 ("tty: move obsolete and broken tty drivers to
drivers/staging/tty/") and a6afd9f3e8 ("tty: move a number of tty drivers
from drivers/char/ to drivers/tty/") moved files around.

Update patterns and orphan some files that were moved to staging.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff -puN MAINTAINERS~maintainers-update-various-tty-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-various-tty-patterns
+++ a/MAINTAINERS
@@ -184,10 +184,9 @@ F:	Documentation/filesystems/9p.txt
 F:	fs/9p/
 
 A2232 SERIAL BOARD DRIVER
-M:	Enver Haase <A2232@gmx.net>
 L:	linux-m68k@lists.linux-m68k.org
-S:	Maintained
-F:	drivers/char/ser_a2232*
+S:	Orphan
+F:	drivers/staging/generic_serial/ser_a2232*
 
 AACRAID SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
@@ -1830,11 +1829,10 @@ S:	Maintained
 F:	drivers/platform/x86/compal-laptop.c
 
 COMPUTONE INTELLIPORT MULTIPORT CARD
-M:	"Michael H. Warfield" <mhw@wittsend.com>
 W:	http://www.wittsend.com/computone.html
-S:	Maintained
+S:	Orphan
 F:	Documentation/serial/computone.txt
-F:	drivers/char/ip2/
+F:	drivers/staging/tty/ip2/
 
 CONEXANT ACCESSRUNNER USB DRIVER
 M:	Simon Arlott <cxacru@fire.lp0.eu>
@@ -2017,7 +2015,7 @@ F:	drivers/net/wan/cycx*
 CYCLADES ASYNC MUX DRIVER
 W:	http://www.cyclades.com/
 S:	Orphan
-F:	drivers/char/cyclades.c
+F:	drivers/tty/cyclades.c
 F:	include/linux/cyclades.h
 
 CYCLADES PC300 DRIVER
@@ -2131,8 +2129,8 @@ L:	Eng.Linux@digi.com
 W:	http://www.digi.com
 S:	Orphan
 F:	Documentation/serial/digiepca.txt
-F:	drivers/char/epca*
-F:	drivers/char/digi*
+F:	drivers/staging/tty/epca*
+F:	drivers/staging/tty/digi*
 
 DIOLAN U2C-12 I2C DRIVER
 M:	Guenter Roeck <guenter.roeck@ericsson.com>
@@ -4205,7 +4203,7 @@ MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CA
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
 F:	Documentation/serial/moxa-smartio
-F:	drivers/char/mxser.*
+F:	drivers/tty/mxser.*
 
 MSI LAPTOP SUPPORT
 M:	"Lee, Chun-Yi" <jlee@novell.com>
@@ -4247,7 +4245,7 @@ F:	sound/oss/msnd*
 
 MULTITECH MULTIPORT CARD (ISICOM)
 S:	Orphan
-F:	drivers/char/isicom.c
+F:	drivers/tty/isicom.c
 F:	include/linux/isicom.h
 
 MUSB MULTIPOINT HIGH SPEED DUAL-ROLE CONTROLLER
@@ -5286,14 +5284,14 @@ F:	drivers/memstick/host/r592.*
 RISCOM8 DRIVER
 S:	Orphan
 F:	Documentation/serial/riscom8.txt
-F:	drivers/char/riscom8*
+F:	drivers/staging/tty/riscom8*
 
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
 S:	Maintained
 F:	Documentation/serial/rocket.txt
-F:	drivers/char/rocket*
+F:	drivers/tty/rocket*
 
 ROSE NETWORK LAYER
 M:	Ralf Baechle <ralf@linux-mips.org>
@@ -5935,10 +5933,9 @@ F:	arch/arm/mach-spear6xx/spear600.c
 F:	arch/arm/mach-spear6xx/spear600_evb.c
 
 SPECIALIX IO8+ MULTIPORT SERIAL CARD DRIVER
-M:	Roger Wolff <R.E.Wolff@BitWizard.nl>
-S:	Supported
+S:	Orphan
 F:	Documentation/serial/specialix.txt
-F:	drivers/char/specialix*
+F:	drivers/staging/tty/specialix*
 
 SPI SUBSYSTEM
 M:	David Brownell <dbrownell@users.sourceforge.net>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-update-m68knommu-patterns.patch
maintainers-update-various-tty-patterns.patch
maintainers-add-k-pattern-for-trivial-patches.patch

