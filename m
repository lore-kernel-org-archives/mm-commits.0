From: akpm@linux-foundation.org
Subject: + update-dontdiff-file.patch added to -mm tree
Date: Thu, 26 Jul 2007 13:36:34 -0700
Message-ID: <200707262036.l6QKaYBD019682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762879AbXGZUgy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 16:36:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     update dontdiff file
has been added to the -mm tree.  Its filename is
     update-dontdiff-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: update dontdiff file
From: Randy Dunlap <randy.dunlap@oracle.com>

Updates based on recent .gitignore updates:

*.o.*: Says Alexey Dobriyan:
These are presumably temporary gcc files, which aren't interesting.

setup.bin, setup.elf: new x86 boot code files (from Matthew Wilcox)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dontdiff |    3 +++
 1 file changed, 3 insertions(+)

diff -puN Documentation/dontdiff~update-dontdiff-file Documentation/dontdiff
--- a/Documentation/dontdiff~update-dontdiff-file
+++ a/Documentation/dontdiff
@@ -18,6 +18,7 @@
 *.moc
 *.mod.c
 *.o
+*.o.*
 *.orig
 *.out
 *.pdf
@@ -163,6 +164,8 @@ raid6tables.c
 relocs
 series
 setup
+setup.bin
+setup.elf
 sim710_d.h*
 sImage
 sm_tbl*
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-fix-for-kmodc.patch
update-dontdiff-file.patch
git-acpi.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
