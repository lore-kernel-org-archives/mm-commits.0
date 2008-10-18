From: akpm@linux-foundation.org
Subject: - docbook-update-procfs-credits.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:48 -0700
Message-ID: <200810182318.m9INImIT029347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbYJRXTq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mouw@nl.linux.org, mm-commits@vger.kernel.org


The patch titled
     docbook: update procfs credits
has been removed from the -mm tree.  Its filename was
     docbook-update-procfs-credits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch

