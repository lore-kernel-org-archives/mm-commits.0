From: akpm@linux-foundation.org
Subject: - docbook-bad-file-references.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:01 -0700
Message-ID: <200707312358.l6VNw1IA029514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbXHAANO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:13:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     docbook bad file references
has been removed from the -mm tree.  Its filename was
     docbook-bad-file-references.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: docbook bad file references
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook warnings:

Warning(linux-2.6.22-git12//drivers/base/power/main.c): no structured comments found
Warning(linux-2.6.22-git12//include/linux/splice.h): no structured comments found

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    2 --
 1 file changed, 2 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~docbook-bad-file-references Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~docbook-bad-file-references
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -380,7 +380,6 @@ X!Edrivers/base/interface.c
 !Edrivers/base/bus.c
      </sect1>
      <sect1><title>Device Drivers Power Management</title>
-!Edrivers/base/power/main.c
 !Edrivers/base/power/resume.c
 !Edrivers/base/power/suspend.c
      </sect1>
@@ -709,7 +708,6 @@ X!Idrivers/video/console/fonts.c
 	kernel, without continually transferring them between the kernel
 	and user space.
   </para>
-!Iinclude/linux/splice.h
 !Ffs/splice.c
   </chapter>
 
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
