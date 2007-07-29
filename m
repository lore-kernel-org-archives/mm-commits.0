From: akpm@linux-foundation.org
Subject: + fix-filemapc-kernel-doc.patch added to -mm tree
Date: Sun, 29 Jul 2007 00:45:44 -0700
Message-ID: <200707290745.l6T7jihh014327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41927 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758030AbXG2Hqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 03:46:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     fix filemap.c kernel-doc
has been added to the -mm tree.  Its filename is
     fix-filemapc-kernel-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix filemap.c kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning:
Warning(linux-2.6.23-rc1-mm1//mm/filemap.c:864): No description found for parameter 'ra'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~fix-filemapc-kernel-doc mm/filemap.c
--- a/mm/filemap.c~fix-filemapc-kernel-doc
+++ a/mm/filemap.c
@@ -843,7 +843,7 @@ static void shrink_readahead_size_eio(st
 /**
  * do_generic_mapping_read - generic file read routine
  * @mapping:	address_space to be read
- * @_ra:	file's readahead state
+ * @ra:		file's readahead state
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
update-dontdiff-file.patch
kernel-doc-fixes-for-pci-and-drivers-base.patch
x86-64-calgary-fix-section-mismatch-warnings-in-tce.patch
various-doc-kernel-parameters-fixes.patch
pnp-fix-kernel-doc-warnings.patch
sched-fix-kernel-doc-warnings.patch
fix-filemapc-kernel-doc.patch
git-acpi.patch
git-mtd.patch
git-net.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
docbook-bad-file-references.patch
kthread-silence-bogus-section-mismatch-warning.patch
profile-likely-unlikely-macros.patch
fix-auditscc-kernel-doc.patch
