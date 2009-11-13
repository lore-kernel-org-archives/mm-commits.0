From: akpm@linux-foundation.org
Subject: + maintainers-kmemcheck-add-file-patterns-use-m-for-pekkas-name-and-address.patch added to -mm tree
Date: Fri, 13 Nov 2009 14:53:02 -0800
Message-ID: <200911132253.nADMr2LV029499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932332AbZKMWxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 17:53:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mingo@elte.hu, penberg@cs.helsinki.fi, vegardno@ifi.uio.no


The patch titled
     MAINTAINERS: KMEMCHECK: add file patterns, use M: for Pekka's name and address
has been added to the -mm tree.  Its filename is
     maintainers-kmemcheck-add-file-patterns-use-m-for-pekkas-name-and-address.patch

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
Subject: MAINTAINERS: KMEMCHECK: add file patterns, use M: for Pekka's name and address
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-kmemcheck-add-file-patterns-use-m-for-pekkas-name-and-address MAINTAINERS
--- a/MAINTAINERS~maintainers-kmemcheck-add-file-patterns-use-m-for-pekkas-name-and-address
+++ a/MAINTAINERS
@@ -3140,9 +3140,13 @@ F:	kernel/kgdb.c
 
 KMEMCHECK
 M:	Vegard Nossum <vegardno@ifi.uio.no>
-P	Pekka Enberg
-M:	penberg@cs.helsinki.fi
+M:	Pekka Enberg <penberg@cs.helsinki.fi>
 S:	Maintained
+F:	Documentation/kmemcheck.txt
+F:	arch/x86/include/asm/kmemcheck.h
+F:	arch/x86/mm/kmemcheck/
+F:	include/linux/kmemcheck.h
+F:	mm/kmemcheck.c
 
 KMEMLEAK
 M:	Catalin Marinas <catalin.marinas@arm.com>
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-kmemcheck-add-file-patterns-use-m-for-pekkas-name-and-address.patch
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

