From: akpm@linux-foundation.org
Subject: + maintainers-update-l-misuses.patch added to -mm tree
Date: Wed, 19 Feb 2014 12:57:16 -0800
Message-ID: <53051aac.ypWkVb+2bUc++Aaz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33198 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaBSU5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 15:57:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pebolle@tiscali.nl, joe@perches.com

Subject: + maintainers-update-l-misuses.patch added to -mm tree
To: joe@perches.com,pebolle@tiscali.nl
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 12:57:16 -0800


The patch titled
     Subject: MAINTAINERS: update L: misuses
has been added to the -mm tree.  Its filename is
     maintainers-update-l-misuses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-l-misuses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-l-misuses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: update L: misuses

L: lines are for the email addresses of traditional mailing lists.
W: lines are for URLs.

Convert two L: misuses to W: links.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-l-misuses MAINTAINERS
--- a/MAINTAINERS~maintainers-update-l-misuses
+++ a/MAINTAINERS
@@ -2610,9 +2610,9 @@ DC395x SCSI driver
 M:	Oliver Neukum <oliver@neukum.org>
 M:	Ali Akcaagac <aliakc@web.de>
 M:	Jamie Lenehan <lenehan@twibble.org>
-W:	http://twibble.org/dist/dc395x/
 L:	dc395x@twibble.org
-L:	http://lists.twibble.org/mailman/listinfo/dc395x/
+W:	http://twibble.org/dist/dc395x/
+W:	http://lists.twibble.org/mailman/listinfo/dc395x/
 S:	Maintained
 F:	Documentation/scsi/dc395x.txt
 F:	drivers/scsi/dc395x.*
@@ -8442,8 +8442,8 @@ TARGET SUBSYSTEM
 M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
 L:	linux-scsi@vger.kernel.org
 L:	target-devel@vger.kernel.org
-L:	http://groups.google.com/group/linux-iscsi-target-dev
 W:	http://www.linux-iscsi.org
+W:	http://groups.google.com/group/linux-iscsi-target-dev
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master
 S:	Supported
 F:	drivers/target/
_

Patches currently in -mm which might be from joe@perches.com are

drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
maintainers-update-l-misuses.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

