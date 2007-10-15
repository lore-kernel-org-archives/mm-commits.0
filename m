From: akpm@linux-foundation.org
Subject: + add-recommended-section-ids-to-deviceiobooktmpl.patch added to -mm tree
Date: Mon, 15 Oct 2007 12:33:28 -0700
Message-ID: <200710151933.l9FJXSbj021186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759518AbXJOTeO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 15:34:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, rdunlap@xenotime.net


The patch titled
     Add recommended section IDs to deviceiobook.tmpl
has been added to the -mm tree.  Its filename is
     add-recommended-section-ids-to-deviceiobooktmpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-arm.patch
git-scsi-misc.patch
docs-ramdisk-initrd-initramfs-corrections.patch
documentation-make-headers_installtxt.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
tweak-documentation-sm501txt.patch
add-missing-entries-to-top-level-documentation-00-index.patch
add-documentation-w1w1-masters-00-index.patch
add-entries-to-documentation-powerpc.patch
add-documentation-power-00-index.patch
add-recommended-section-ids-to-deviceiobooktmpl.patch
