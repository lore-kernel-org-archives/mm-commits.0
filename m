From: akpm@linux-foundation.org
Subject: - lapb-use-the-shorter-list_head-form-for-brevity.patch removed from -mm tree
Date: Wed, 02 Apr 2008 12:20:12 -0700
Message-ID: <200804021920.m32JKCcJ030248@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759845AbYDBT1N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Apr 2008 15:27:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, mm-commits@vger.kernel.org


The patch titled
     lapb: use the shorter LIST_HEAD form for brevity
has been removed from the -mm tree.  Its filename was
     lapb-use-the-shorter-list_head-form-for-brevity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lapb: use the shorter LIST_HEAD form for brevity
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/lapbether.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wan/lapbether.c~lapb-use-the-shorter-list_head-form-for-brevity drivers/net/wan/lapbether.c
--- a/drivers/net/wan/lapbether.c~lapb-use-the-shorter-list_head-form-for-brevity
+++ a/drivers/net/wan/lapbether.c
@@ -58,7 +58,7 @@ struct lapbethdev {
 	struct net_device_stats stats;		/* some statistics */
 };
 
-static struct list_head lapbeth_devices = LIST_HEAD_INIT(lapbeth_devices);
+static LIST_HEAD(lapbeth_devices);
 
 /* ------------------------------------------------------------------------ */
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
efs-update-error-msg-to-not-refer-to-deleted-read_inode.patch
git-powerpc.patch
git-ieee1394.patch
git-infiniband.patch
mmc-use-shorter-equivalent-set_current_state.patch
git-net.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
mfd-use-shorter-set_current_state.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch

