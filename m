From: akpm@linux-foundation.org
Subject: - docbook-librs-typo-fixes.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:36 -0700
Message-ID: <200705090252.l492qa4V009589@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968848AbXEICwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docbook: librs typo fixes
has been removed from the -mm tree.  Its filename was
     docbook-librs-typo-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: docbook: librs typo fixes
From: Randy Dunlap <randy.dunlap@oracle.com>

librs docbook typo fixes.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/librs.tmpl |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN Documentation/DocBook/librs.tmpl~docbook-librs-typo-fixes Documentation/DocBook/librs.tmpl
--- a/Documentation/DocBook/librs.tmpl~docbook-librs-typo-fixes
+++ a/Documentation/DocBook/librs.tmpl
@@ -79,12 +79,12 @@
   <chapter id="usage">
      	<title>Usage</title>
 	<para>
-		This chapter provides examples how to use the library.
+		This chapter provides examples of how to use the library.
 	</para>
 	<sect1>
 		<title>Initializing</title>
 		<para>
-			The init function init_rs returns a pointer to a
+			The init function init_rs returns a pointer to an
 			rs decoder structure, which holds the necessary
 			information for encoding, decoding and error correction
 			with the given polynomial. It either uses an existing
@@ -98,10 +98,10 @@
 static struct rs_control *rs_decoder;
 
 /* Symbolsize is 10 (bits)
- * Primitve polynomial is x^10+x^3+1
+ * Primitive polynomial is x^10+x^3+1
  * first consecutive root is 0
- * primitve element to generate roots = 1
- * generator polinomial degree (number of roots) = 6
+ * primitive element to generate roots = 1
+ * generator polynomial degree (number of roots) = 6
  */
 rs_decoder = init_rs (10, 0x409, 0, 1, 6);
 		</programlisting>
@@ -116,12 +116,12 @@ rs_decoder = init_rs (10, 0x409, 0, 1, 6
 		</para>
 		<para>
 			The expanded data can be inverted on the fly by
-			providing a non zero inversion mask. The expanded data is
+			providing a non-zero inversion mask. The expanded data is
 			XOR'ed with the mask. This is used e.g. for FLASH
 			ECC, where the all 0xFF is inverted to an all 0x00.
 			The Reed-Solomon code for all 0x00 is all 0x00. The
 			code is inverted before storing to FLASH so it is 0xFF
-			too. This prevent's that reading from an erased FLASH
+			too. This prevents that reading from an erased FLASH
 			results in ECC errors.
 		</para>
 		<para>
@@ -273,7 +273,7 @@ free_rs(rs_decoder);
  		May be used under the terms of the GNU General Public License (GPL)
 	</programlisting>
 	<para>
-		The wrapper functions and interfaces are written by Thomas Gleixner
+		The wrapper functions and interfaces are written by Thomas Gleixner.
 	</para>
 	<para>
 		Many users have provided bugfixes, improvements and helping hands for testing.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
krealloc-fix-kerneldoc-comments.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
lib-hexdump-fix.patch
lib-hexdump-update-on-feedback.patch
doc-what-a-patch-series-is.patch
kernel-doc-small-kernel-doc-optimization.patch
profile-likely-unlikely-macros.patch
