From: akpm@linux-foundation.org
Subject: + doc-what-a-patch-series-is.patch added to -mm tree
Date: Tue, 08 May 2007 14:11:32 -0700
Message-ID: <200705082111.l48LBWjY001750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032167AbXEHVLl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:11:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     doc: what a patch series is
has been added to the -mm tree.  Its filename is
     doc-what-a-patch-series-is.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: doc: what a patch series is
From: Randy Dunlap <randy.dunlap@oracle.com>

It seems that we need to clarify that a patch series is a series of related
patches rather than "here are some of my patches as multiple (numbered)
emails."

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~doc-what-a-patch-series-is Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~doc-what-a-patch-series-is
+++ a/Documentation/SubmittingPatches
@@ -363,7 +363,8 @@ area or subsystem of the kernel is being
 The "summary phrase" in the email's Subject should concisely
 describe the patch which that email contains.  The "summary
 phrase" should not be a filename.  Do not use the same "summary
-phrase" for every patch in a whole patch series.
+phrase" for every patch in a whole patch series (where a "patch
+series" is an ordered sequence of multiple, related patches).
 
 Bear in mind that the "summary phrase" of your email becomes
 a globally-unique identifier for that patch.  It propagates
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
parport_serial-fix-pci-must_checks.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
kernel-doc-html-mode-struct-highlights.patch
taskstats-fix-getdelays-usage-information.patch
introduce-a-handy-list_first_entry-macro-v2.patch
consolidate-asm-consth-to-linux-consth.patch
x86_64-kill-19000-sparse-warnings.patch
move-log_buf_shift-to-a-more-sensible-place.patch
doc-fix-oops-tracing-duplicate.patch
docbook-librs-typo-fixes.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
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
profile-likely-unlikely-macros.patch
