From: akpm@linux-foundation.org
Subject: - include-linux-sysctlh-remove-empty-else.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:47:41 -0700
Message-ID: <200804300547.m3U5lfqR029727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756845AbYD3GBv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     include/linux/sysctl.h: remove empty #else
has been removed from the -mm tree.  Its filename was
     include-linux-sysctlh-remove-empty-else.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/sysctl.h: remove empty #else
From: Adrian Bunk <bunk@kernel.org>

Remove an empty #else.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/sysctl.h~include-linux-sysctlh-remove-empty-else include/linux/sysctl.h
--- a/include/linux/sysctl.h~include-linux-sysctlh-remove-empty-else
+++ a/include/linux/sysctl.h
@@ -1085,8 +1085,6 @@ struct ctl_table_header *register_sysctl
 void unregister_sysctl_table(struct ctl_table_header * table);
 int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table);
 
-#else /* __KERNEL__ */
-
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_SYSCTL_H */
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

