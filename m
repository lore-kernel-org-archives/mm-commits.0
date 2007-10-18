From: akpm@linux-foundation.org
Subject: - add-recommended-section-ids-to-deviceiobooktmpl.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:59 -0700
Message-ID: <200710180704.l9I74x6A031606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50048 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761054AbXJRHRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:17:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Add recommended section IDs to deviceiobook.tmpl
has been removed from the -mm tree.  Its filename was
     add-recommended-section-ids-to-deviceiobooktmpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add recommended section IDs to deviceiobook.tmpl
From: Rob Landley <rob@landley.net>

Add recommended section ID tags to deviceiobook.tmpl

Because otherwise the link #anchors in the html vary from build to build.

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/deviceiobook.tmpl |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/DocBook/deviceiobook.tmpl~add-recommended-section-ids-to-deviceiobooktmpl Documentation/DocBook/deviceiobook.tmpl
--- a/Documentation/DocBook/deviceiobook.tmpl~add-recommended-section-ids-to-deviceiobooktmpl
+++ a/Documentation/DocBook/deviceiobook.tmpl
@@ -85,7 +85,7 @@
 
   <chapter id="mmio">
     <title>Memory Mapped IO</title>
-    <sect1>
+    <sect1 id="getting_access_to_the_device">
       <title>Getting Access to the Device</title>
       <para>
 	The most widely supported form of IO is memory mapped IO.
@@ -114,7 +114,7 @@
       </para>
     </sect1>
 
-    <sect1>
+    <sect1 id="accessing_the_device">
       <title>Accessing the device</title>
       <para>
 	The part of the interface most used by drivers is reading and
@@ -272,9 +272,9 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
 
   </chapter>
 
-  <chapter>
+  <chapter id="port_space_accesses">
     <title>Port Space Accesses</title>
-    <sect1>
+    <sect1 id="port_space_explained">
       <title>Port Space Explained</title>
 
       <para>
@@ -291,7 +291,7 @@ CPU B:  spin_unlock_irqrestore(&amp;dev_
       </para>
 
     </sect1>
-    <sect1>
+    <sect1 id="accessing_port_space">
       <title>Accessing Port Space</title>
       <para>
 	Accesses to this space are provided through a set of functions
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
