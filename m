From: akpm@linux-foundation.org
Subject: - dontdiff-update-based-on-gitignore-updates.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:02:03 -0700
Message-ID: <200710180702.l9I723b1031233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58400 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760038AbXJRH1T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:27:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bunk@stusta.de, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dontdiff: update based on gitignore updates
has been removed from the -mm tree.  Its filename was
     dontdiff-update-based-on-gitignore-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dontdiff: update based on gitignore updates
From: Randy Dunlap <randy.dunlap@oracle.com>

Update dontdiff, based on .gitignore patches from Pete Zaitcev and Adrian
Bunk.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dontdiff |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN Documentation/dontdiff~dontdiff-update-based-on-gitignore-updates Documentation/dontdiff
--- a/Documentation/dontdiff~dontdiff-update-based-on-gitignore-updates
+++ a/Documentation/dontdiff
@@ -42,6 +42,9 @@
 *.9.gz
 .*
 .cscope
+.gitignore
+.mailmap
+.mm
 53c700_d.h
 53c7xx_d.h
 53c7xx_u.h
@@ -175,11 +178,13 @@ times.h*
 tkparse
 trix_boot.h
 utsrelease.h*
+vdso.lds
 version.h*
 vmlinux
 vmlinux-*
 vmlinux.aout
-vmlinux.lds
+vmlinux*.lds*
+vmlinux*.scr
 vsyscall.lds
 wanxlfw.inc
 uImage
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
i-oat-cleanup-pci-issues.patch
profile-likely-unlikely-macros.patch
