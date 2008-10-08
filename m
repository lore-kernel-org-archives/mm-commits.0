From: akpm@linux-foundation.org
Subject: + docbook-update-procfs-credits.patch added to -mm tree
Date: Wed, 08 Oct 2008 14:44:30 -0700
Message-ID: <200810082144.m98LiUIl011545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756105AbYJHVp5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Oct 2008 17:45:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mouw@nl.linux.org


The patch titled
     docbook: update procfs credits
has been added to the -mm tree.  Its filename is
     docbook-update-procfs-credits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docbook: update procfs credits
From: Randy Dunlap <randy.dunlap@oracle.com>

Update Erik Mouw's email address & affiliation in DocBook.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Erik Mouw <mouw@nl.linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/procfs-guide.tmpl |   29 +++++++---------------
 Documentation/DocBook/procfs_example.c  |   20 +++------------
 2 files changed, 14 insertions(+), 35 deletions(-)

diff -puN Documentation/DocBook/procfs-guide.tmpl~docbook-update-procfs-credits Documentation/DocBook/procfs-guide.tmpl
--- a/Documentation/DocBook/procfs-guide.tmpl~docbook-update-procfs-credits
+++ a/Documentation/DocBook/procfs-guide.tmpl
@@ -14,17 +14,20 @@
 	<othername>(J.A.K.)</othername>
 	<surname>Mouw</surname>
 	<affiliation>
-	  <orgname>Delft University of Technology</orgname>
-	  <orgdiv>Faculty of Information Technology and Systems</orgdiv>
 	  <address>
-            <email>J.A.K.Mouw@its.tudelft.nl</email>
-            <pob>PO BOX 5031</pob>
-            <postcode>2600 GA</postcode>
-            <city>Delft</city>
-            <country>The Netherlands</country>
+            <email>mouw@nl.linux.org</email>
           </address>
 	</affiliation>
       </author>
+      <othercredit>
+	<contrib>
+	This software and documentation were written while working on the
+	LART computing board
+	(<ulink url="http://www.lartmaker.nl/">http://www.lartmaker.nl/</ulink>),
+	which was sponsored by the Delt University of Technology projects
+	Mobile Multi-media Communications and Ubiquitous Communications.
+	</contrib>
+      </othercredit>
     </authorgroup>
 
     <revhistory>
@@ -109,18 +112,6 @@
     </para>
 
     <para>
-      This documentation was written while working on the LART
-      computing board (<ulink
-      url="http://www.lart.tudelft.nl/">http://www.lart.tudelft.nl/</ulink>),
-      which is sponsored by the Mobile Multi-media Communications
-      (<ulink
-      url="http://www.mmc.tudelft.nl/">http://www.mmc.tudelft.nl/</ulink>)
-      and Ubiquitous Communications (<ulink
-      url="http://www.ubicom.tudelft.nl/">http://www.ubicom.tudelft.nl/</ulink>)
-      projects.
-    </para>
-
-    <para>
       Erik
     </para>
   </preface>
diff -puN Documentation/DocBook/procfs_example.c~docbook-update-procfs-credits Documentation/DocBook/procfs_example.c
--- a/Documentation/DocBook/procfs_example.c~docbook-update-procfs-credits
+++ a/Documentation/DocBook/procfs_example.c
@@ -1,28 +1,16 @@
 /*
  * procfs_example.c: an example proc interface
  *
- * Copyright (C) 2001, Erik Mouw (J.A.K.Mouw@its.tudelft.nl)
+ * Copyright (C) 2001, Erik Mouw (mouw@nl.linux.org)
  *
  * This file accompanies the procfs-guide in the Linux kernel
  * source. Its main use is to demonstrate the concepts and
  * functions described in the guide.
  *
  * This software has been developed while working on the LART
- * computing board (http://www.lart.tudelft.nl/), which is
- * sponsored by the Mobile Multi-media Communications
- * (http://www.mmc.tudelft.nl/) and Ubiquitous Communications 
- * (http://www.ubicom.tudelft.nl/) projects.
- *
- * The author can be reached at:
- *
- *  Erik Mouw
- *  Information and Communication Theory Group
- *  Faculty of Information Technology and Systems
- *  Delft University of Technology
- *  P.O. Box 5031
- *  2600 GA Delft
- *  The Netherlands
- *
+ * computing board (http://www.lartmaker.nl), which was sponsored
+ * by the Delt University of Technology projects Mobile Multi-media
+ * Communications and Ubiquitous Communications.
  *
  * This program is free software; you can redistribute
  * it and/or modify it under the terms of the GNU General
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-tip.patch
git-hid.patch
git-acpi.patch
git-net.patch
git-sound.patch
git-block.patch
git-slab.patch
git-drm.patch
git-security-testing.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fb-metronome-printk-format-warning.patch
toshiba_acpi-depends-on-input.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
eeepc-laptop-use-standard-interfaces-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
docbook-update-procfs-credits.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support-fix.patch
profile-likely-unlikely-macros.patch

