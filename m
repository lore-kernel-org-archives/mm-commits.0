From: akpm@linux-foundation.org
Subject: [merged] maintainers-correct-security-subsystem-git-entry.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:05 -0800
Message-ID: <200911131927.nADJR5Ev029824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932212AbZKMT1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: correct SECURITY SUBSYSTEM git entry
has been removed from the -mm tree.  Its filename was
     maintainers-correct-security-subsystem-git-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: correct SECURITY SUBSYSTEM git entry
From: Joe Perches <joe@perches.com>

Use git.kernel.org not www.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-correct-security-subsystem-git-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-correct-security-subsystem-git-entry
+++ a/MAINTAINERS
@@ -4635,7 +4635,7 @@ F:	drivers/mmc/host/sdhci-s3c.c
 SECURITY SUBSYSTEM
 M:	James Morris <jmorris@namei.org>
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
-T:	git git://www.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git
 W:	http://security.wiki.kernel.org/
 S:	Supported
 F:	security/
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

