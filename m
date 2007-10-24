From: akpm@linux-foundation.org
Subject: + add-chapter-ids-to-z8530booktmpl.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:50:54 -0700
Message-ID: <200710242250.l9OMosis016593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43760 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758527AbXJXWu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, rdunlap@xenotime.net


The patch titled
     Add chapter IDs to z8530book.tmpl
has been added to the -mm tree.  Its filename is
     add-chapter-ids-to-z8530booktmpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add chapter IDs to z8530book.tmpl
From: Rob Landley <rob@landley.net>

Add chapter IDs to z8530book.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/z8530book.tmpl |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/DocBook/z8530book.tmpl~add-chapter-ids-to-z8530booktmpl Documentation/DocBook/z8530book.tmpl
--- a/Documentation/DocBook/z8530book.tmpl~add-chapter-ids-to-z8530booktmpl
+++ a/Documentation/DocBook/z8530book.tmpl
@@ -77,7 +77,7 @@
   </para>
   </chapter>
   
-  <chapter>
+  <chapter id="Driver_Modes">
  	<title>Driver Modes</title>
   <para>
 	The Z85230 driver layer can drive Z8530, Z85C30 and Z85230 devices
@@ -108,7 +108,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Using_the_Z85230_driver">
  	<title>Using the Z85230 driver</title>
   <para>
 	The Z85230 driver provides the back end interface to your board. To
@@ -174,7 +174,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Attaching_Network_Interfaces">
  	<title>Attaching Network Interfaces</title>
   <para>
 	If you wish to use the network interface facilities of the driver,
@@ -216,7 +216,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Configuring_And_Activating_The_Port">
  	<title>Configuring And Activating The Port</title>
   <para>
 	The Z85230 driver provides helper functions and tables to load the
@@ -300,7 +300,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Network_Layer_Functions">
  	<title>Network Layer Functions</title>
   <para>
 	The Z8530 layer provides functions to queue packets for
@@ -327,7 +327,7 @@
   </para>
   </chapter>
 
-  <chapter>
+  <chapter id="Porting_The_Z8530_Driver">
      <title>Porting The Z8530 Driver</title>
   <para>
 	The Z8530 driver is written to be portable. In DMA mode it makes
_

Patches currently in -mm which might be from rob@landley.net are

add-missing-section-ids-to-genericirqtmpl.patch
add-missing-section-ids-to-genericirqtmpl-updated.patch
add-missing-section-id-to-lsmtmpl.patch
add-section-ids-to-mtdnandtmpl.patch
add-missing-ids-to-procfs-guidetmpl.patch
add-section-ids-to-rapidiotmpl.patch
add-table-ids-to-videobooktmpl.patch
add-chapter-ids-to-z8530booktmpl.patch
