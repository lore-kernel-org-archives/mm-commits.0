From: akpm@linux-foundation.org
Subject: + maintainers-whitespace-fixes.patch added to -mm tree
Date: Tue, 05 Jun 2012 15:51:09 -0700
Message-ID: <20120605225109.52C6EA0297@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:54953 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2FEWvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 18:51:11 -0400
Received: by wibhn6 with SMTP id hn6so282802wib.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 15:51:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     Subject: MAINTAINERS: whitespace fixes
has been added to the -mm tree.  Its filename is
     maintainers-whitespace-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: whitespace fixes

Remove trailing spaces at EOL.
Always use a tab after the type :

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN MAINTAINERS~maintainers-whitespace-fixes MAINTAINERS
--- a/MAINTAINERS~maintainers-whitespace-fixes
+++ a/MAINTAINERS
@@ -1077,7 +1077,7 @@ F:	drivers/media/video/s5p-fimc/
 ARM/SAMSUNG S5P SERIES Multi Format Codec (MFC) SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Kamil Debski <k.debski@samsung.com>
-M:     Jeongtae Park <jtp.park@samsung.com>
+M:	Jeongtae Park <jtp.park@samsung.com>
 L:	linux-arm-kernel@lists.infradead.org
 L:	linux-media@vger.kernel.org
 S:	Maintained
@@ -1743,10 +1743,10 @@ F:	include/linux/can/platform/
 CAPABILITIES
 M:	Serge Hallyn <serge.hallyn@canonical.com>
 L:	linux-security-module@vger.kernel.org
-S:	Supported	
+S:	Supported
 F:	include/linux/capability.h
 F:	security/capability.c
-F:	security/commoncap.c 
+F:	security/commoncap.c
 F:	kernel/capability.c
 
 CELL BROADBAND ENGINE ARCHITECTURE
@@ -2146,11 +2146,11 @@ S:	Orphan
 F:	drivers/net/wan/pc300*
 
 CYTTSP TOUCHSCREEN DRIVER
-M:      Javier Martinez Canillas <javier@dowhile0.org>
-L:      linux-input@vger.kernel.org
-S:      Maintained
-F:      drivers/input/touchscreen/cyttsp*
-F:      include/linux/input/cyttsp.h
+M:	Javier Martinez Canillas <javier@dowhile0.org>
+L:	linux-input@vger.kernel.org
+S:	Maintained
+F:	drivers/input/touchscreen/cyttsp*
+F:	include/linux/input/cyttsp.h
 
 DAMA SLAVE for AX.25
 M:	Joerg Reuter <jreuter@yaina.de>
@@ -5193,7 +5193,7 @@ S:	Maintained
 F:	drivers/firmware/pcdp.*
 
 PCI ERROR RECOVERY
-M:     Linas Vepstas <linasvepstas@gmail.com>
+M:	Linas Vepstas <linasvepstas@gmail.com>
 L:	linux-pci@vger.kernel.org
 S:	Supported
 F:	Documentation/PCI/pci-error-recovery.txt
_
Subject: Subject: MAINTAINERS: whitespace fixes

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-whitespace-fixes.patch

