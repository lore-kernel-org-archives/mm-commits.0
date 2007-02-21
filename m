From: akpm@linux-foundation.org
Subject: - git-unionfs-fixup.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:42:12 -0800
Message-ID: <200702211042.l1LAgCuI006274@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46684 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394AbXBUKmS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:42:18 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1LAgChB015774
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2007 02:42:13 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-unionfs-fixup
has been removed from the -mm tree.  Its filename was
     git-unionfs-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-unionfs-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   15 ---------------
 1 file changed, 15 deletions(-)

diff -puN fs/Kconfig~git-unionfs-fixup fs/Kconfig
--- a/fs/Kconfig~git-unionfs-fixup
+++ a/fs/Kconfig
@@ -1121,21 +1121,6 @@ config AFFS_FS
 	  To compile this file system support as a module, choose M here: the
 	  module will be called affs.  If unsure, say N.
 
-<<<<<<< HEAD/fs/Kconfig
-config ECRYPT_FS
-	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && CRYPTO && NET
-	help
-	  Encrypted filesystem that operates on the VFS layer.  See
-	  <file:Documentation/ecryptfs.txt> to learn more about
-	  eCryptfs.  Userspace components are required and can be
-	  obtained from <http://ecryptfs.sf.net>.
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called ecryptfs.
-
-=======
->>>>>>> /fs/Kconfig
 config HFS_FS
 	tristate "Apple Macintosh file system support (EXPERIMENTAL)"
 	depends on BLOCK && EXPERIMENTAL
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-agpgart.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-unionfs.patch
git-unionfs-fixup.patch
after-before-x86_64-mm-mmconfig-share.patch
xen-paravirt-core-xen-implementation-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
