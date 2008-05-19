From: akpm@linux-foundation.org
Subject: + update-cell-and-spufs-maintainers-entry.patch added to -mm tree
Date: Mon, 19 May 2008 14:40:02 -0700
Message-ID: <200805192140.m4JLe2sj021851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760360AbYESVkn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:40:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, jk@ozlabs.org


The patch titled
     Update Cell and spufs MAINTAINERS entry
has been added to the -mm tree.  Its filename is
     update-cell-and-spufs-maintainers-entry.patch

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
Subject: Update Cell and spufs MAINTAINERS entry
From: Arnd Bergmann <arnd@arndb.de>

The MAINTAINERS file entry for the cell platform is outdated, even the
name of the platform changed since the early days when it was initially
submitted.  The SPU file system is now maintained by Jeremy Kerr.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jeremy Kerr <jk@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN MAINTAINERS~update-cell-and-spufs-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~update-cell-and-spufs-maintainers-entry
+++ a/MAINTAINERS
@@ -982,13 +982,6 @@ L:	bonding-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/bonding/
 S:	Supported
 
-BROADBAND PROCESSOR ARCHITECTURE
-P:	Arnd Bergmann
-M:	arnd@arndb.de
-L:	linuxppc-dev@ozlabs.org
-W:	http://www.penguinppc.org/ppc64/
-S:	Supported
-
 BROADCOM B44 10/100 ETHERNET DRIVER
 P:	Gary Zambrano
 M:	zambrano@broadcom.com
@@ -1052,6 +1045,14 @@ L:	linux-kernel@vger.kernel.org
 L:	discuss@x86-64.org
 S:	Maintained
 
+CELL BROADBAND ENGINE ARCHITECTURE
+P:	Arnd Bergmann
+M:	arnd@arndb.de
+L:	linuxppc-dev@ozlabs.org
+L:	cbe-oss-dev@ozlabs.org
+W:	http://www.ibm.com/developerworks/power/cell/
+S:	Supported
+
 CFAG12864B LCD DRIVER
 P:	Miguel Ojeda Sandonis
 M:	maxextreme@gmail.com
@@ -3774,6 +3775,14 @@ M:	dbrownell@users.sourceforge.net
 L:	spi-devel-general@lists.sourceforge.net
 S:	Maintained
 
+SPU FILE SYSTEM
+P:	Jeremy Kerr
+M:	jk@ozlabs.org
+L:	linuxppc-dev@ozlabs.org
+L:	cbe-oss-dev@ozlabs.org
+W:	http://www.ibm.com/developerworks/power/cell/
+S:	Supported
+
 STABLE BRANCH:
 P:	Greg Kroah-Hartman
 M:	greg@kroah.com
_

Patches currently in -mm which might be from arnd@arndb.de are

update-cell-and-spufs-maintainers-entry.patch
access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch

