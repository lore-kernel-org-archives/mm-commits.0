From: akpm@linux-foundation.org
Subject: [merged] maintainers-brocade-bfa-use-single-line-m-and-tabs.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:25:48 -0800
Message-ID: <200911131925.nADJPmj5026635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757070AbZKMTZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:25:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, huangj@brocade.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: BROCADE BFA - Use single line M: and tabs
has been removed from the -mm tree.  Its filename was
     maintainers-brocade-bfa-use-single-line-m-and-tabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: BROCADE BFA - Use single line M: and tabs
From: Joe Perches <joe@perches.com>

Integrate P:/M: to single M:
Use tab for spacing

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jing Huang <huangj@brocade.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-brocade-bfa-use-single-line-m-and-tabs MAINTAINERS
--- a/MAINTAINERS~maintainers-brocade-bfa-use-single-line-m-and-tabs
+++ a/MAINTAINERS
@@ -1244,11 +1244,10 @@ S:	Supported
 F:	drivers/net/tg3.*
 
 BROCADE BFA FC SCSI DRIVER
-P:      Jing Huang
-M:      huangj@brocade.com
-L:      linux-scsi@vger.kernel.org
-S:      Supported
-F:      drivers/scsi/bfa/
+M:	Jing Huang <huangj@brocade.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/bfa/
 
 BSG (block layer generic sg v4 driver)
 M:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
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

