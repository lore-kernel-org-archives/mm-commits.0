From: akpm@linux-foundation.org
Subject: + maintainers-add-and-correct-types-of-some-t-entries.patch added to -mm tree
Date: Wed, 26 Feb 2014 15:28:13 -0800
Message-ID: <530e788d.C9D+tIxHFZZZlc3S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaBZX2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 18:28:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + maintainers-add-and-correct-types-of-some-t-entries.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 15:28:13 -0800


The patch titled
     Subject: MAINTAINERS: add and correct types of some "T:" entries
has been added to the -mm tree.  Its filename is
     maintainers-add-and-correct-types-of-some-t-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-and-correct-types-of-some-t-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-and-correct-types-of-some-t-entries.patch

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
Subject: MAINTAINERS: add and correct types of some "T:" entries

Tree location entries should start with the appropriate type.

Add git to some, hg to another.

Neaten tree type description.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN MAINTAINERS~maintainers-add-and-correct-types-of-some-t-entries MAINTAINERS
--- a/MAINTAINERS~maintainers-add-and-correct-types-of-some-t-entries
+++ a/MAINTAINERS
@@ -73,7 +73,8 @@ Descriptions of section entries:
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
 	Q: Patchwork web based patch tracking system site
-	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit, topgit.
+	T: SCM tree type and location.
+	   Type is one of: git, hg, quilt, stgit, topgit
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
 	   Maintained:	Someone actually looks after it.
@@ -2159,7 +2160,7 @@ F:	Documentation/zh_CN/
 
 CHIPIDEA USB HIGH SPEED DUAL ROLE CONTROLLER
 M:	Peter Chen <Peter.Chen@freescale.com>
-T:	git://github.com/hzpeterchen/linux-usb.git
+T:	git git://github.com/hzpeterchen/linux-usb.git
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/chipidea/
@@ -2382,7 +2383,7 @@ M:	Lorenzo Pieralisi <lorenzo.pieralisi@
 M:	Daniel Lezcano <daniel.lezcano@linaro.org>
 L:	linux-pm@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
 S:	Maintained
 F:	drivers/cpuidle/cpuidle-big_little.c
 
@@ -2391,7 +2392,7 @@ M:	Rafael J. Wysocki <rjw@rjwysocki.net>
 M:	Daniel Lezcano <daniel.lezcano@linaro.org>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
-T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
 F:	drivers/cpuidle/*
 F:	include/linux/cpuidle.h
 
@@ -4904,7 +4905,7 @@ F:	drivers/staging/ktap/
 KCONFIG
 M:	"Yann E. MORIN" <yann.morin.1998@free.fr>
 L:	linux-kbuild@vger.kernel.org
-T:	git://gitorious.org/linux-kconfig/linux-kconfig
+T:	git git://gitorious.org/linux-kconfig/linux-kconfig
 S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
@@ -5719,7 +5720,7 @@ L:	linux-rdma@vger.kernel.org
 W:	http://www.mellanox.com
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-T:	git://openfabrics.org/~eli/connect-ib.git
+T:	git git://openfabrics.org/~eli/connect-ib.git
 S:	Supported
 F:	drivers/net/ethernet/mellanox/mlx5/core/
 F:	include/linux/mlx5/
@@ -5729,7 +5730,7 @@ M:	Eli Cohen <eli@mellanox.com>
 L:	linux-rdma@vger.kernel.org
 W:	http://www.mellanox.com
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-T:	git://openfabrics.org/~eli/connect-ib.git
+T:	git git://openfabrics.org/~eli/connect-ib.git
 S:	Supported
 F:	include/linux/mlx5/
 F:	drivers/infiniband/hw/mlx5/
@@ -9798,7 +9799,7 @@ ZR36067 VIDEO FOR LINUX DRIVER
 L:	mjpeg-users@lists.sourceforge.net
 L:	linux-media@vger.kernel.org
 W:	http://mjpeg.sourceforge.net/driver-zoran/
-T:	Mercurial http://linuxtv.org/hg/v4l-dvb
+T:	hg http://linuxtv.org/hg/v4l-dvb
 S:	Odd Fixes
 F:	drivers/media/pci/zoran/
 
_

Patches currently in -mm which might be from joe@perches.com are

drivers-iommu-omap-iommu-debugc-fix-decimal-permissions.patch
drivers-fmc-fmc-write-eepromc-fix-decimal-permissions.patch
maintainers-update-l-misuses.patch
maintainers-use-tab-for-separator.patch
maintainers-add-and-correct-types-of-some-t-entries.patch
lib-random32c-minor-cleanups-and-kdoc-fix.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
checkpatch-add-checks-for-constant-non-octal-permissions.patch
checkpatch-warn-on-uses-of-__constant_foo-functions.patch
checkpatch-update-octal-permissions-warning.patch
checkpatch-avoid-sscanf-test-duplicated-messages.patch
checkpatch-fix-jiffies-comparison-and-others.patch
checkpatch-add-test-for-char-arrays-that-could-be-static-const.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

