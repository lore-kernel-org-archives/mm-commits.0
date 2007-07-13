From: akpm@linux-foundation.org
Subject: + docbook-dont-reference-file-without-kernel-doc.patch added to -mm tree
Date: Fri, 13 Jul 2007 01:26:27 -0700
Message-ID: <200707130826.l6D8QRI1008292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761360AbXGMI0w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 04:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     docbook: don't reference file without kernel-doc
has been added to the -mm tree.  Its filename is
     docbook-dont-reference-file-without-kernel-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: docbook: don't reference file without kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Remove include/linux/rmap.h from kernel-api.tmpl since it no longer
contains kernel-doc.  Fixes this warning:

Warning(linux-2.6.22//include/linux/rmap.h): no structured comments found

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~docbook-dont-reference-file-without-kernel-doc Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbook-dont-reference-file-without-kernel-doc
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -159,7 +159,6 @@ X!Ilib/string.c
 !Earch/i386/lib/usercopy.c
      </sect1>
      <sect1><title>More Memory Management Functions</title>
-!Iinclude/linux/rmap.h
 !Emm/readahead.c
 !Emm/filemap.c
 !Emm/memory.c
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-alsa.patch
git-mtd.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
hugetlbfs-use-lib-parser-fix-docs-fix.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
docbook-dont-reference-file-without-kernel-doc.patch
profile-likely-unlikely-macros.patch
