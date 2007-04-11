From: akpm@linux-foundation.org
Subject: + alphabetically-sorted-entries-in.patch added to -mm tree
Date: Wed, 11 Apr 2007 12:54:32 -0700
Message-ID: <200704111954.l3BJsWmM012913@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58287 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030308AbXDKTyh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 15:54:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, bbpetkov@yahoo.de


The patch titled
     alphabetically-sorted entries in index.html of 'htmldocs'
has been added to the -mm tree.  Its filename is
     alphabetically-sorted-entries-in.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alphabetically-sorted entries in index.html of 'htmldocs'
From: Randy Dunlap <randy.dunlap@oracle.com>

Make docbook index.html contain sorted output.

I prefer to let the computer do it.  This also avoids people not reading
the comment(s).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Borislav Petkov <bbpetkov@yahoo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/Makefile~alphabetically-sorted-entries-in Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~alphabetically-sorted-entries-in
+++ a/Documentation/DocBook/Makefile
@@ -41,7 +41,7 @@ psdocs: $(PS)
 PDF := $(patsubst %.xml, %.pdf, $(BOOKS))
 pdfdocs: $(PDF)
 
-HTML := $(patsubst %.xml, %.html, $(BOOKS))
+HTML := $(sort $(patsubst %.xml, %.html, $(BOOKS)))
 htmldocs: $(HTML)
 	$(call build_main_index)
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

fix-kernel-oops-with-badly-formatted-module-option.patch
git-acpi.patch
git-drm.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
8250_pci-fix-pci-must_checks.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-mtrr-sections.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
expose-range-checking-functions-from-arch-specific.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
