From: akpm@linux-foundation.org
Subject: + uml-add-missing-space.patch added to -mm tree
Date: Tue, 20 Nov 2007 13:25:25 -0800
Message-ID: <200711202125.lAKLPPHg024222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755603AbXKTVZ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Nov 2007 16:25:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jdike@linux.intel.com


The patch titled
     uml: add missing space
has been added to the -mm tree.  Its filename is
     uml-add-missing-space.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-acpi.patch
git-dvb.patch
git-jfs.patch
git-kvm.patch
git-ocfs2.patch
git-selinux.patch
git-s390.patch
git-sparc64.patch
uml-add-missing-space.patch
