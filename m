From: akpm@linux-foundation.org
Subject: - docbook-dont-reference-file-without-kernel-doc.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:02:10 -0700
Message-ID: <200707192002.l6JK2AcX019632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761991AbXGSUQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docbook: don't reference file without kernel-doc
has been removed from the -mm tree.  Its filename was
     docbook-dont-reference-file-without-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
profile-likely-unlikely-macros.patch
