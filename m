From: akpm@linux-foundation.org
Subject: + dontdiff-update-based-on-gitignore-updates.patch added to -mm tree
Date: Fri, 05 Oct 2007 17:13:36 -0700
Message-ID: <200710060013.l960Daua032124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35851 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755944AbXJFAOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 20:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, bunk@stusta.de, zaitcev@redhat.com


The patch titled
     dontdiff: update based on gitignore updates
has been added to the -mm tree.  Its filename is
     dontdiff-update-based-on-gitignore-updates.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-alsa.patch
fix-auditscc-kernel-doc.patch
git-kbuild.patch
menuconfig-distinguish-between-selected-by-another-options-and-comments.patch
git-mtd.patch
git-net.patch
git-nfsd.patch
pci-implement-pci=noaer.patch
git-scsi-misc.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
kgdb-fix-help-text.patch
kgdb-fix-docbook-and-kernel-doc-typos.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix-function-declaration.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
docs-ramdisk-initrd-initramfs-corrections.patch
send-quota-messages-via-netlink-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
maintainers-linux-omap-list-is-subscribers-only.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
doc-about-email-clients-for-linux-patches.patch
change-inotifyfs-magic-as-the-same-magic-is-used-for-futexfs-v2.patch
dont-truncate-proc-pid-environ-at-4096-characters.patch
dontdiff-update-based-on-gitignore-updates.patch
ecryptfs-remove-header_extent_size-fix.patch
video-gfx-fix-menu-ordering.patch
video-gfx-merge-kconfig-menus.patch
kernel-doc-fix-doc-blocks-and-html.patch
express-relocatability-of-kernel-on-x86_64-in.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
