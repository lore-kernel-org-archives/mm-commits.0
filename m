From: akpm@linux-foundation.org
Subject: + parport_pcc-use-correct-length-in-strncmp.patch added to -mm tree
Date: Fri, 13 Nov 2009 14:27:33 -0800
Message-ID: <200911132227.nADMRXuJ001764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756542AbZKMW1a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 17:27:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, alan@linux.intel.com


The patch titled
     parport_pc.c: use correct length in strncmp
has been added to the -mm tree.  Its filename is
     parport_pcc-use-correct-length-in-strncmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: parport_pc.c: use correct length in strncmp
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_pc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/parport_pc.c~parport_pcc-use-correct-length-in-strncmp drivers/parport/parport_pc.c
--- a/drivers/parport/parport_pc.c~parport_pcc-use-correct-length-in-strncmp
+++ a/drivers/parport/parport_pc.c
@@ -3403,7 +3403,7 @@ static int __init parport_parse_param(co
 		*val = automatic;
 	else if (!strncmp(s, "none", 4))
 		*val = none;
-	else if (nofifo && !strncmp(s, "nofifo", 4))
+	else if (nofifo && !strncmp(s, "nofifo", 6))
 		*val = nofifo;
 	else {
 		char *ep;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
scripts-get_maintainerpl-support-multiple-vcss-add-mercurial.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch
parport_pcc-use-correct-length-in-strncmp.patch

