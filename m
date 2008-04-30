From: akpm@linux-foundation.org
Subject: - cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:42:08 -0700
Message-ID: <200804300542.m3U5g8Ag029120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757420AbYD3GKr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:10:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: kernel/ns_cgroup.c should #include <linux/nsproxy.h>
has been removed from the -mm tree.  Its filename was
     cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: kernel/ns_cgroup.c should #include <linux/nsproxy.h>
From: Adrian Bunk <bunk@kernel.org>

Every file should include the headers containing the externs its global
functions (in this case for ns_cgroup_clone()).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ns_cgroup.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/ns_cgroup.c~cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh kernel/ns_cgroup.c
--- a/kernel/ns_cgroup.c~cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh
+++ a/kernel/ns_cgroup.c
@@ -8,6 +8,7 @@
 #include <linux/cgroup.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/nsproxy.h>
 
 struct ns_cgroup {
 	struct cgroup_subsys_state css;
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

