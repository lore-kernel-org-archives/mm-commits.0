From: akpm@linux-foundation.org
Subject: - add-section-ids-to-rapidiotmpl.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:02:08 -0800
Message-ID: <200802080801.m1881nbW013992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48456 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754699AbYBHIBw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:01:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Add section IDs to rapidio.tmpl
has been removed from the -mm tree.  Its filename was
     add-section-ids-to-rapidiotmpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
 !Iarch/powerpc/kernel/rio.c
 !Earch/powerpc/sysdev/fsl_rio.c
 !Iarch/powerpc/sysdev/fsl_rio.c
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
irq_noprobe-helper-functions.patch
mips-mark-all-but-i8259-interrupts-as-no-probe.patch
