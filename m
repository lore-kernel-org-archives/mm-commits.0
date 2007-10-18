From: akpm@linux-foundation.org
Subject: - add-section-ids-to-documentation-docbook-filesystemstmpl.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:05:05 -0700
Message-ID: <200710180705.l9I755kk031622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48772 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763AbXJRHPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:15:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Add section IDs to Documentation/DocBook/filesystems.tmpl
has been removed from the -mm tree.  Its filename was
     add-section-ids-to-documentation-docbook-filesystemstmpl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add section IDs to Documentation/DocBook/filesystems.tmpl
From: Rob Landley <rob@landley.net>

Add recommended section IDs to Documentation/DocBook/filesystems.tmpl

Signed-off-by: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/filesystems.tmpl |   36 +++++++++++------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN Documentation/DocBook/filesystems.tmpl~add-section-ids-to-documentation-docbook-filesystemstmpl Documentation/DocBook/filesystems.tmpl
--- a/Documentation/DocBook/filesystems.tmpl~add-section-ids-to-documentation-docbook-filesystemstmpl
+++ a/Documentation/DocBook/filesystems.tmpl
@@ -40,25 +40,25 @@
 
   <chapter id="vfs">
      <title>The Linux VFS</title>
-     <sect1><title>The Filesystem types</title>
+     <sect1 id="the_filesystem_types"><title>The Filesystem types</title>
 !Iinclude/linux/fs.h
      </sect1>
-     <sect1><title>The Directory Cache</title>
+     <sect1 id="the_directory_cache"><title>The Directory Cache</title>
 !Efs/dcache.c
 !Iinclude/linux/dcache.h
      </sect1>
-     <sect1><title>Inode Handling</title>
+     <sect1 id="inode_handling"><title>Inode Handling</title>
 !Efs/inode.c
 !Efs/bad_inode.c
      </sect1>
-     <sect1><title>Registration and Superblocks</title>
+     <sect1 id="registration_and_superblocks"><title>Registration and Superblocks</title>
 !Efs/super.c
      </sect1>
-     <sect1><title>File Locks</title>
+     <sect1 id="file_locks"><title>File Locks</title>
 !Efs/locks.c
 !Ifs/locks.c
      </sect1>
-     <sect1><title>Other Functions</title>
+     <sect1 id="other_functions"><title>Other Functions</title>
 !Efs/mpage.c
 !Efs/namei.c
 !Efs/buffer.c
@@ -73,11 +73,11 @@
   <chapter id="proc">
      <title>The proc filesystem</title>
 
-     <sect1><title>sysctl interface</title>
+     <sect1 id="sysctl_interface"><title>sysctl interface</title>
 !Ekernel/sysctl.c
      </sect1>
 
-     <sect1><title>proc filesystem interface</title>
+     <sect1 id="proc_filesystem_interface"><title>proc filesystem interface</title>
 !Ifs/proc/base.c
      </sect1>
   </chapter>
@@ -92,7 +92,7 @@
   <chapter id="debugfs">
      <title>The debugfs filesystem</title>
 
-     <sect1><title>debugfs interface</title>
+     <sect1 id="debugfs_interface"><title>debugfs interface</title>
 !Efs/debugfs/inode.c
 !Efs/debugfs/file.c
      </sect1>
@@ -134,9 +134,9 @@
 
   <title>The Linux Journalling API</title>
 
-    <sect1>
+    <sect1 id="journaling_overview">
      <title>Overview</title>
-    <sect2>
+    <sect2 id="journaling_details">
      <title>Details</title>
 <para>
 The journalling layer is  easy to use. You need to
@@ -307,7 +307,7 @@ particular inode.
 
     </sect2>
 
-    <sect2>
+    <sect2 id="jbd_summary">
      <title>Summary</title>
 <para>
 Using the journal is a matter of wrapping the different context changes,
@@ -349,7 +349,7 @@ an example.
 
     </sect1>
 
-    <sect1>
+    <sect1 id="data_types">
      <title>Data Types</title>
      <para>
 	The journalling layer uses typedefs to 'hide' the concrete definitions
@@ -358,27 +358,27 @@ an example.
 
 	Obviously the hiding is not enforced as this is 'C'.
      </para>
-	<sect2><title>Structures</title>
+	<sect2 id="structures"><title>Structures</title>
 !Iinclude/linux/jbd.h
 	</sect2>
     </sect1>
 
-    <sect1>
+    <sect1 id="functions">
      <title>Functions</title>
      <para>
 	The functions here are split into two groups those that
 	affect a journal as a whole, and those which are used to
 	manage transactions
      </para>
-	<sect2><title>Journal Level</title>
+	<sect2 id="journal_level"><title>Journal Level</title>
 !Efs/jbd/journal.c
 !Ifs/jbd/recovery.c
 	</sect2>
-	<sect2><title>Transasction Level</title>
+	<sect2 id="transaction_level"><title>Transasction Level</title>
 !Efs/jbd/transaction.c
 	</sect2>
     </sect1>
-    <sect1>
+    <sect1 id="see_also">
      <title>See also</title>
 	<para>
 	  <citation>
_

Patches currently in -mm which might be from rob@landley.net are

origin.patch
comment-typo-in-scripts-kconfig-makefile.patch
