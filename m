From: akpm@linux-foundation.org
Subject: + add-missing-ids-to-procfs-guidetmpl.patch added to -mm tree
Date: Wed, 24 Oct 2007 15:50:47 -0700
Message-ID: <200710242250.l9OMolaV016583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41187 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759615AbXJXWvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 18:51:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob@landley.net, rdunlap@xenotime.net


The patch titled
     Add missing IDs to procfs-guide.tmpl
has been added to the -mm tree.  Its filename is
     add-missing-ids-to-procfs-guidetmpl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add missing IDs to procfs-guide.tmpl
From: Rob Landley <rob@landley.net>

Add missing IDs to procfs-guide.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/procfs-guide.tmpl |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN Documentation/DocBook/procfs-guide.tmpl~add-missing-ids-to-procfs-guidetmpl Documentation/DocBook/procfs-guide.tmpl
--- a/Documentation/DocBook/procfs-guide.tmpl~add-missing-ids-to-procfs-guidetmpl
+++ a/Documentation/DocBook/procfs-guide.tmpl
@@ -85,7 +85,7 @@
 
 
 
-  <preface>
+  <preface id="Preface">
     <title>Preface</title>
 
     <para>
@@ -230,7 +230,7 @@
 
 
 
-    <sect1>
+    <sect1 id="Creating_a_symlink">
       <title>Creating a symlink</title>
 
       <funcsynopsis>
@@ -254,7 +254,7 @@
       </para>
     </sect1>
 
-    <sect1>
+    <sect1 id="Creating_a_directory">
       <title>Creating a directory</title>
       
       <funcsynopsis>
@@ -274,7 +274,7 @@
 
 
 
-    <sect1>
+    <sect1 id="Removing_an_entry">
       <title>Removing an entry</title>
       
       <funcsynopsis>
@@ -340,7 +340,7 @@ entry->write_proc = write_proc_foo;
 
 
 
-    <sect1>
+    <sect1 id="Reading_data">
       <title>Reading data</title>
 
       <para>
@@ -448,7 +448,7 @@ entry->write_proc = write_proc_foo;
 
 
 
-    <sect1>
+    <sect1 id="Writing_data">
       <title>Writing data</title>
 
       <para>
@@ -579,7 +579,7 @@ int foo_read_func(char *page, char **sta
 
 
 
-    <sect1>
+    <sect1 id="Modules">
       <title>Modules</title>
 
       <para>
@@ -599,7 +599,7 @@ entry->owner = THIS_MODULE;
 
 
 
-    <sect1>
+    <sect1 id="Mode_and_ownership">
       <title>Mode and ownership</title>
 
       <para>
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
