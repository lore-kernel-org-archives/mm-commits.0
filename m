From: akpm@linux-foundation.org
Subject: + maintainers-rename-palm-treo-section-and-file-patterns.patch added to -mm tree
Date: Tue, 08 Dec 2009 15:23:29 -0800
Message-ID: <200912082323.nB8NNT27032117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936954AbZLHXX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 18:23:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, sleep_walker@suse.cz


The patch titled
     MAINTAINERS: rename PALM TREO section and file patterns
has been added to the -mm tree.  Its filename is
     maintainers-rename-palm-treo-section-and-file-patterns.patch

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
Subject: MAINTAINERS: rename PALM TREO section and file patterns
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Tomas Cech <sleep_walker@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-rename-palm-treo-section-and-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-rename-palm-treo-section-and-file-patterns
+++ a/MAINTAINERS
@@ -822,13 +822,13 @@ F:	arch/arm/mach-pxa/palmte2.c
 F:	arch/arm/mach-pxa/include/mach/palmtc.h
 F:	arch/arm/mach-pxa/palmtc.c
 
-ARM/PALM TREO 680 SUPPORT
+ARM/PALM TREO SUPPORT
 M:	Tomas Cech <sleep_walker@suse.cz>
 L:	linux-arm-kernel@lists.infradead.org
 W:	http://hackndev.com
 S:	Maintained
-F:	arch/arm/mach-pxa/include/mach/treo680.h
-F:	arch/arm/mach-pxa/treo680.c
+F:	arch/arm/mach-pxa/include/mach/palmtreo.h
+F:	arch/arm/mach-pxa/palmtreo.c
 
 ARM/PALMZ72 SUPPORT
 M:	Sergey Lapin <slapin@ossfans.org>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
scripts-get_maintainerpl-support-multiple-vcss-add-mercurial.patch
maintainers-rename-palm-treo-section-and-file-patterns.patch
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

