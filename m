From: akpm@linux-foundation.org
Subject: - fs-timerfdc-should-include-linux-syscallsh.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:35 -0700
Message-ID: <200804300539.m3U5dZNB028861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbYD3Fjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     fs/timerfd.c should #include <linux/syscalls.h>
has been removed from the -mm tree.  Its filename was
     fs-timerfdc-should-include-linux-syscallsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/timerfd.c should #include <linux/syscalls.h>
From: Adrian Bunk <bunk@kernel.org>

Every file should include the headers containing the prototypes for its global
functions (in this case for sys_timerfd_*()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/timerfd.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/timerfd.c~fs-timerfdc-should-include-linux-syscallsh fs/timerfd.c
--- a/fs/timerfd.c~fs-timerfdc-should-include-linux-syscallsh
+++ a/fs/timerfd.c
@@ -20,6 +20,7 @@
 #include <linux/hrtimer.h>
 #include <linux/anon_inodes.h>
 #include <linux/timerfd.h>
+#include <linux/syscalls.h>
 
 struct timerfd_ctx {
 	struct hrtimer tmr;
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

