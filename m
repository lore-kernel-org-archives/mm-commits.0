From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:32:51 -0800
Message-ID: <200702150832.l1F8WpJh024580@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39361 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965258AbXBOIc5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:32:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/namespace.c~r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix fs/namespace.c
--- a/fs/namespace.c~r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix
+++ a/fs/namespace.c
@@ -78,7 +78,7 @@ struct vfsmount *alloc_vfsmnt(const char
 
 int mnt_want_write(struct vfsmount *mnt)
 {
-	if (__mnt_is_readonly(mnt));
+	if (__mnt_is_readonly(mnt))
 		return -EROFS;
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
git-drm.patch
git-dvb.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
Fabric7-VIOC-driver-fixes.patch
git-backlight.patch
git-backlight-sony-fix.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
before-x86_64-mm-mmconfig-share.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
revert-x86_64-mm-putreg-check.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions-fix.patch
r-o-bind-mounts-r-o-bind-mounts-stub-functions-unhack.patch
git-gccbug-fixup.patch
