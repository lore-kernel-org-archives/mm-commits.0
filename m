From: akpm@linux-foundation.org
Subject: [folded] namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch removed from -mm tree
Date: Mon, 06 Apr 2009 15:29:58 -0700
Message-ID: <200904062229.n36MTw2b015924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbZDFWdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 18:33:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Nadia.Derbey@bull.net, adobriyan@gmail.com, clg@fr.ibm.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     mqueue-namespace-adapt-sysctl-update-fix
has been removed from the -mm tree.  Its filename was
     namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch

This patch was dropped because it was folded into namespaces-mqueue-namespace-adapt-sysctl.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mqueue-namespace-adapt-sysctl-update-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mq_sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/mq_sysctl.c~namespaces-mqueue-namespace-adapt-sysctl-update-fix ipc/mq_sysctl.c
--- a/ipc/mq_sysctl.c~namespaces-mqueue-namespace-adapt-sysctl-update-fix
+++ a/ipc/mq_sysctl.c
@@ -52,8 +52,8 @@ static int proc_mq_dointvec_minmax(ctl_t
 					lenp, ppos);
 }
 #else
-proc_handler *proc_mq_dointvec = NULL;
-proc_handler *proc_mq_dointvec_minmax = NULL;
+#define proc_mq_dointvec NULL
+#define proc_mq_dointvec_minmax NULL
 #endif
 
 static int msg_max_limit_min = MIN_MSGMAX;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-add-proc-controls-for-pdflush-threads.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
vfs-simple_set_mnt-should-return-void-fix-nilfs.patch
nilfs2-segment-buffer-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
page-owner-tracking.patch
page-owner-tracking-checkpatch-fixes.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch

