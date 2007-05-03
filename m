From: akpm@linux-foundation.org
Subject: + docbook-librs-typo-fixes.patch added to -mm tree
Date: Thu, 03 May 2007 01:33:55 -0700
Message-ID: <200705030833.l438XtIx008158@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932332AbXECIeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 04:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     docbook: librs typo fixes
has been added to the -mm tree.  Its filename is
     docbook-librs-typo-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-acpi.patch
git-drm.patch
git-ieee1394.patch
git-kbuild.patch
romfs-printk-format-warnings.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kernel-doc-html-mode-struct-highlights.patch
taskstats-fix-getdelays-usage-information.patch
introduce-a-handy-list_first_entry-macro-v2.patch
add-pci_try_set_mwi.patch
consolidate-asm-consth-to-linux-consth.patch
x86_64-kill-19000-sparse-warnings.patch
move-log_buf_shift-to-a-more-sensible-place.patch
doc-fix-oops-tracing-duplicate.patch
docbook-librs-typo-fixes.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
