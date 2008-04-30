From: akpm@linux-foundation.org
Subject: - remove-ecryptfs_header_cache_0.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:46 -0700
Message-ID: <200804300541.m3U5fkIu029077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757484AbYD3Fmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     remove ecryptfs_header_cache_0
has been removed from the -mm tree.  Its filename was
     remove-ecryptfs_header_cache_0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove ecryptfs_header_cache_0
From: Adrian Bunk <bunk@kernel.org>

Remove the no longer used ecryptfs_header_cache_0.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/crypto.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ecryptfs/crypto.c~remove-ecryptfs_header_cache_0 fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~remove-ecryptfs_header_cache_0
+++ a/fs/ecryptfs/crypto.c
@@ -1246,7 +1246,6 @@ ecryptfs_write_header_metadata(char *vir
 	(*written) = 6;
 }
 
-struct kmem_cache *ecryptfs_header_cache_0;
 struct kmem_cache *ecryptfs_header_cache_1;
 struct kmem_cache *ecryptfs_header_cache_2;
 
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

