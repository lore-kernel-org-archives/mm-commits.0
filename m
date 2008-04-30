From: akpm@linux-foundation.org
Subject: - make-fs-bufferccont_expand_zero-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:39 -0700
Message-ID: <200804300539.m3U5ddfi028869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbYD3Fj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make fs/buffer.c:cont_expand_zero() static
has been removed from the -mm tree.  Its filename was
     make-fs-bufferccont_expand_zero-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make fs/buffer.c:cont_expand_zero() static
From: Adrian Bunk <bunk@kernel.org>

cont_expand_zero() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/buffer.c~make-fs-bufferccont_expand_zero-static fs/buffer.c
--- a/fs/buffer.c~make-fs-bufferccont_expand_zero-static
+++ a/fs/buffer.c
@@ -2211,8 +2211,8 @@ out:
 	return err;
 }
 
-int cont_expand_zero(struct file *file, struct address_space *mapping,
-			loff_t pos, loff_t *bytes)
+static int cont_expand_zero(struct file *file, struct address_space *mapping,
+			    loff_t pos, loff_t *bytes)
 {
 	struct inode *inode = mapping->host;
 	unsigned blocksize = 1 << inode->i_blkbits;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

