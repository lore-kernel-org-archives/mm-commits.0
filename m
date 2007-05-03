From: akpm@linux-foundation.org
Subject: - alphabetically-sorted-entries-in.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:39 -0700
Message-ID: <200705031931.l43JVdbZ018280@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767878AbXECTdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bbpetkov@yahoo.de, mm-commits@vger.kernel.org


The patch titled
     alphabetically-sorted entries in index.html of 'htmldocs'
has been removed from the -mm tree.  Its filename was
     alphabetically-sorted-entries-in.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
git-drm.patch
git-ieee1394.patch
git-kbuild.patch
romfs-printk-format-warnings.patch
git-net.patch
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
