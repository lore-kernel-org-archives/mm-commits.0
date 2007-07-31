From: akpm@linux-foundation.org
Subject: - update-dontdiff-file.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:54:35 -0700
Message-ID: <200707312354.l6VNsZDK029155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48298 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756199AbXGaXyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 19:54:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     update dontdiff file
has been removed from the -mm tree.  Its filename was
     update-dontdiff-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
