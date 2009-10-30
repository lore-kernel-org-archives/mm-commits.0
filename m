From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-score-architecture-name-style-and-add-file-pattern.patch removed from -mm tree
Date: Fri, 30 Oct 2009 13:49:19 -0700
Message-ID: <200910302049.n9UKnJWZ007904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33229 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757504AbZJ3UuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 16:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update SCORE architecture name style and add file pattern
has been removed from the -mm tree.  Its filename was
     maintainers-update-score-architecture-name-style-and-add-file-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update SCORE architecture name style and add file pattern
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN MAINTAINERS~maintainers-update-score-architecture-name-style-and-add-file-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-update-score-architecture-name-style-and-add-file-pattern
+++ a/MAINTAINERS
@@ -4521,12 +4521,11 @@ F:	kernel/sched*
 F:	include/linux/sched.h
 
 SCORE ARCHITECTURE
-P:	Chen Liqin
-M:	liqin.chen@sunplusct.com
-P:	Lennox Wu
-M:	lennox.wu@gmail.com
+M:	Chen Liqin <liqin.chen@sunplusct.com>
+M:	Lennox Wu <lennox.wu@gmail.com>
 W:	http://www.sunplusct.com
 S:	Supported
+F:	arch/score/
 
 SCSI CDROM DRIVER
 M:	Jens Axboe <axboe@kernel.dk>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-asus-acpi-extras-remove-f-arch-x86-kernel-acpi-bootc.patch
maintainers-brocade-bfa-use-single-line-m-and-tabs.patch
maintainers-server-engines-10gbps-iscsi-use-single-line-m.patch
maintainers-vmware-vmxnet3-quote-name-with-comma-and-period-use-tabs.patch
get_maintainer-fix-usage-comment.patch
linux-next.patch
dynamic_debugh-kernelh-remove-kbuild_modname-from-dynamic_pr_debug.patch
kernelh-remove-initialization-of-bool-in-printk_once.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
lib-vsprintfc-add-%pu-to-print-uuid-guids.patch
fs-xfs-xfs_log_recoverc-use-%pu-to-print-uuids.patch
randomc-use-%pu-to-print-uuids.patch
drivers-firmware-dmi_scanc-use-%pub-to-print-uuids.patch
drivers-md-mdc-use-%pu-to-print-uuids.patch
fs-gfs2-sysc-use-%pub-to-print-uuids.patch
fs-ubifs-use-%pub-to-print-uuids.patch
efih-use-%pul-to-print-uuids.patch
drivers-media-video-uvc-use-%pul-to-print-uuids.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch
isicomc-use-pr_fmt-and-pr_level.patch

