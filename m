From: akpm@linux-foundation.org
Subject: - ipmi-make-alloc_recv_msg-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:03 -0700
Message-ID: <200804300545.m3U5j3Gw029470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758966AbYD3Fub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, cminyard@mvista.com, mm-commits@vger.kernel.org


The patch titled
     ipmi: make alloc_recv_msg static
has been removed from the -mm tree.  Its filename was
     ipmi-make-alloc_recv_msg-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipmi: make alloc_recv_msg static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global ipmi_alloc_recv_msg() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-make-alloc_recv_msg-static drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-make-alloc_recv_msg-static
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -3932,7 +3932,7 @@ static void free_recv_msg(struct ipmi_re
 	kfree(msg);
 }
 
-struct ipmi_recv_msg *ipmi_alloc_recv_msg(void)
+static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void)
 {
 	struct ipmi_recv_msg *rv;
 
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

