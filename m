From: akpm@linux-foundation.org
Subject: + docbook-bad-file-references.patch added to -mm tree
Date: Thu, 19 Jul 2007 14:42:52 -0700
Message-ID: <200707192142.l6JLgqP1024524@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55586 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759062AbXGSVnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 17:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     docbook bad file references
has been added to the -mm tree.  Its filename is
     docbook-bad-file-references.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 deletions(-)

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
 	kernel, without continually transferring it between the kernel
 	and user space.
   </para>
-!Iinclude/linux/splice.h
 !Ffs/splice.c
   </chapter>
 
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
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
usbh-kernel-doc-additions.patch
docbook-bad-file-references.patch
profile-likely-unlikely-macros.patch
