From: akpm@linux-foundation.org
Subject: + documentation-howto-update-urls-of-git-trees.patch added to -mm tree
Date: Mon, 25 Jun 2007 22:11:18 -0700
Message-ID: <200706260511.l5Q5BIsN018945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756763AbXFZFLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 01:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefanr@s5r6.in-berlin.de


The patch titled
     Documentation/HOWTO: update URLs of git trees
has been added to the -mm tree.  Its filename is
     documentation-howto-update-urls-of-git-trees.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation/HOWTO: update URLs of git trees
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Also, remove outdated 1394 tree and mention MAINTAINERS as pointer to
development trees.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/HOWTO |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -puN Documentation/HOWTO~documentation-howto-update-urls-of-git-trees Documentation/HOWTO
--- a/Documentation/HOWTO~documentation-howto-update-urls-of-git-trees
+++ a/Documentation/HOWTO
@@ -322,39 +322,34 @@ kernel releases as described above.
 Here is a list of some of the different kernel trees available:
   git trees:
     - Kbuild development tree, Sam Ravnborg <sam@ravnborg.org>
-	kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
+	git.kernel.org:/pub/scm/linux/kernel/git/sam/kbuild.git
 
     - ACPI development tree, Len Brown <len.brown@intel.com>
-	kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
 
     - Block development tree, Jens Axboe <axboe@suse.de>
-	kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
+	git.kernel.org:/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
 
     - DRM development tree, Dave Airlie <airlied@linux.ie>
-	kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 
     - ia64 development tree, Tony Luck <tony.luck@intel.com>
-	kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
-
-    - ieee1394 development tree, Jody McIntyre <scjody@modernduck.com>
-	kernel.org:/pub/scm/linux/kernel/git/scjody/ieee1394.git
+	git.kernel.org:/pub/scm/linux/kernel/git/aegl/linux-2.6.git
 
     - infiniband, Roland Dreier <rolandd@cisco.com>
-	kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
+	git.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git
 
     - libata, Jeff Garzik <jgarzik@pobox.com>
-	kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
+	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
 
     - network drivers, Jeff Garzik <jgarzik@pobox.com>
-	kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
 
     - pcmcia, Dominik Brodowski <linux@dominikbrodowski.net>
-	kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
+	git.kernel.org:/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git
 
     - SCSI, James Bottomley <James.Bottomley@SteelEye.com>
-	kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
-
-  Other git kernel trees can be found listed at http://kernel.org/git
+	git.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
 
   quilt trees:
     - USB, PCI, Driver Core, and I2C, Greg Kroah-Hartman <gregkh@suse.de>
@@ -362,6 +357,9 @@ Here is a list of some of the different 
     - x86-64, partly i386, Andi Kleen <ak@suse.de>
         ftp.firstfloor.org:/pub/ak/x86_64/quilt/
 
+  Other kernel trees can be found listed at http://git.kernel.org/ and in
+  the MAINTAINERS file.
+
 Bug Reporting
 -------------
 
_

Patches currently in -mm which might be from stefanr@s5r6.in-berlin.de are

documentation-howto-update-urls-of-git-trees.patch
git-ieee1394.patch
git-scsi-misc.patch
fs-clarify-dummy-member-in-struct.patch
