From: akpm@linux-foundation.org
Subject: + if-0-v9fs_fid_lookup_remove.patch added to -mm tree
Date: Thu, 16 Aug 2007 14:08:33 -0700
Message-ID: <200708162108.l7GL8XE3006813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754410AbXHPVI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 17:08:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, ericvh@gmail.com, lucho@ionkov.net


The patch titled
     #if 0 v9fs_fid_lookup_remove()
has been added to the -mm tree.  Its filename is
     if-0-v9fs_fid_lookup_remove.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: #if 0 v9fs_fid_lookup_remove()
From: Adrian Bunk <bunk@kernel.org>

This patch #if 0's the unused v9fs_fid_lookup_remove().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/fid.c |    2 ++
 fs/9p/fid.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/9p/fid.c~if-0-v9fs_fid_lookup_remove fs/9p/fid.c
--- a/fs/9p/fid.c~if-0-v9fs_fid_lookup_remove
+++ a/fs/9p/fid.c
@@ -92,6 +92,7 @@ struct p9_fid *v9fs_fid_lookup(struct de
 	return fid;
 }
 
+#if 0
 struct p9_fid *v9fs_fid_lookup_remove(struct dentry *dentry)
 {
 	struct p9_fid *fid;
@@ -107,6 +108,7 @@ struct p9_fid *v9fs_fid_lookup_remove(st
 
 	return fid;
 }
+#endif  /*  0  */
 
 
 /**
diff -puN fs/9p/fid.h~if-0-v9fs_fid_lookup_remove fs/9p/fid.h
--- a/fs/9p/fid.h~if-0-v9fs_fid_lookup_remove
+++ a/fs/9p/fid.h
@@ -28,6 +28,5 @@ struct v9fs_dentry {
 };
 
 struct p9_fid *v9fs_fid_lookup(struct dentry *dentry);
-struct p9_fid *v9fs_fid_lookup_remove(struct dentry *dentry);
 struct p9_fid *v9fs_fid_clone(struct dentry *dentry);
 int v9fs_fid_add(struct dentry *dentry, struct p9_fid *fid);
_

Patches currently in -mm which might be from bunk@kernel.org are

pass-g-to-assembler-under-config_debug_info-fix.patch
alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
if-0-v9fs_fid_lookup_remove.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
