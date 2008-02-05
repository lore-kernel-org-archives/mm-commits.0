From: akpm@linux-foundation.org
Subject: - uml-add-missing-space.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:36:55 -0800
Message-ID: <200802052236.m15Maadq012721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760429AbYBEWlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: add missing space
has been removed from the -mm tree.  Its filename was
     uml-add-missing-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: add missing space
From: Joe Perches <joe@perches.com>

Add missing space between merged string constants.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/vde_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/um/drivers/vde_user.c~uml-add-missing-space arch/um/drivers/vde_user.c
--- a/arch/um/drivers/vde_user.c~uml-add-missing-space
+++ a/arch/um/drivers/vde_user.c
@@ -80,7 +80,7 @@ void vde_init_libstuff(struct vde_data *
 
 	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
-		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args"
+		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
 		       "allocation failed");
 		return;
 	}
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
git-cpufreq.patch
git-hwmon.patch
git-kvm.patch
git-unionfs.patch
printk_ratelimit-functions-should-use-config_printk.patch
