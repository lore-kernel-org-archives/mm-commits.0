From: akpm@linux-foundation.org
Subject: + add-section-ids-to-rapidiotmpl.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:50:49 -0700
Message-ID: <200710242250.l9OMoni0016586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759828AbXJXWvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, rdunlap@xenotime.net


The patch titled
     Add section IDs to rapidio.tmpl
has been added to the -mm tree.  Its filename is
     add-section-ids-to-rapidiotmpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add section IDs to rapidio.tmpl
From: Rob Landley <rob@landley.net>

Add section IDs to rapidio.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/rapidio.tmpl |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN Documentation/DocBook/rapidio.tmpl~add-section-ids-to-rapidiotmpl Documentation/DocBook/rapidio.tmpl
--- a/Documentation/DocBook/rapidio.tmpl~add-section-ids-to-rapidiotmpl
+++ a/Documentation/DocBook/rapidio.tmpl
@@ -77,11 +77,11 @@
   <chapter id="bugs">
      <title>Known Bugs and Limitations</title>
 
-     <sect1>
+     <sect1 id="known_bugs">
      	<title>Bugs</title>
 	  <para>None. ;)</para>
      </sect1>
-     <sect1>
+     <sect1 id="Limitations">
      	<title>Limitations</title>
 	  <para>
 	    <orderedlist>
@@ -100,7 +100,7 @@
 		on devices, request/map memory region resources,
 		and manage mailboxes/doorbells.
 	</para>
-	<sect1>
+	<sect1 id="Functions">
 		<title>Functions</title>
 !Iinclude/linux/rio_drv.h
 !Edrivers/rapidio/rio-driver.c
@@ -116,23 +116,23 @@
      subsystem.
      </para>
 
-     <sect1><title>Structures</title>
+     <sect1 id="Structures"><title>Structures</title>
 !Iinclude/linux/rio.h
      </sect1>
-     <sect1><title>Enumeration and Discovery</title>
+     <sect1 id="Enumeration_and_Discovery"><title>Enumeration and Discovery</title>
 !Idrivers/rapidio/rio-scan.c
      </sect1>
-     <sect1><title>Driver functionality</title>
+     <sect1 id="Driver_functionality"><title>Driver functionality</title>
 !Idrivers/rapidio/rio.c
 !Idrivers/rapidio/rio-access.c
      </sect1>
-     <sect1><title>Device model support</title>
+     <sect1 id="Device_model_support"><title>Device model support</title>
 !Idrivers/rapidio/rio-driver.c
      </sect1>
-     <sect1><title>Sysfs support</title>
+     <sect1 id="Sysfs_support"><title>Sysfs support</title>
 !Idrivers/rapidio/rio-sysfs.c
      </sect1>
-     <sect1><title>PPC32 support</title>
+     <sect1 id="PPC32_support"><title>PPC32 support</title>
 !Iarch/ppc/kernel/rio.c
 !Earch/ppc/syslib/ppc85xx_rio.c
 !Iarch/ppc/syslib/ppc85xx_rio.c
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
