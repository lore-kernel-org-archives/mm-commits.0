From: akpm@linux-foundation.org
Subject: [merged] maintainers-use-tab-for-separator.patch removed from -mm tree
Date: Thu, 06 Mar 2014 12:37:51 -0800
Message-ID: <5318dc9f.h1nTBjHumbuMiaRW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaCFUhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2014 15:37:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: [merged] maintainers-use-tab-for-separator.patch removed from -mm tree
To: joe@perches.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 06 Mar 2014 12:37:51 -0800


The patch titled
     Subject: MAINTAINERS: use tab for separator
has been removed from the -mm tree.  Its filename was
     maintainers-use-tab-for-separator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: use tab for separator

Convert whitespace to single tab for separators.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   88 +++++++++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff -puN MAINTAINERS~maintainers-use-tab-for-separator MAINTAINERS
--- a/MAINTAINERS~maintainers-use-tab-for-separator
+++ a/MAINTAINERS
@@ -1612,11 +1612,11 @@ S:	Maintained
 F:	drivers/net/wireless/atmel*
 
 ATTO EXPRESSSAS SAS/SATA RAID SCSI DRIVER
-M:      Bradley Grove <linuxdrivers@attotech.com>
-L:      linux-scsi@vger.kernel.org
-W:      http://www.attotech.com
-S:      Supported
-F:      drivers/scsi/esas2r
+M:	Bradley Grove <linuxdrivers@attotech.com>
+L:	linux-scsi@vger.kernel.org
+W:	http://www.attotech.com
+S:	Supported
+F:	drivers/scsi/esas2r
 
 AUDIT SUBSYSTEM
 M:	Eric Paris <eparis@redhat.com>
@@ -2179,9 +2179,9 @@ S:	Supported
 F:	drivers/net/ethernet/cisco/enic/
 
 CISCO VIC LOW LATENCY NIC DRIVER
-M:      Upinder Malhi <umalhi@cisco.com>
-S:      Supported
-F:      drivers/infiniband/hw/usnic
+M:	Upinder Malhi <umalhi@cisco.com>
+S:	Supported
+F:	drivers/infiniband/hw/usnic
 
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
 M:	Hartley Sweeten <hsweeten@visionengravers.com>
@@ -2378,13 +2378,13 @@ F:	drivers/cpufreq/arm_big_little.c
 F:	drivers/cpufreq/arm_big_little_dt.c
 
 CPUIDLE DRIVER - ARM BIG LITTLE
-M:      Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
-M:      Daniel Lezcano <daniel.lezcano@linaro.org>
-L:      linux-pm@vger.kernel.org
-L:      linux-arm-kernel@lists.infradead.org
-T:      git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
-S:      Maintained
-F:      drivers/cpuidle/cpuidle-big_little.c
+M:	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
+M:	Daniel Lezcano <daniel.lezcano@linaro.org>
+L:	linux-pm@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
+S:	Maintained
+F:	drivers/cpuidle/cpuidle-big_little.c
 
 CPUIDLE DRIVERS
 M:	Rafael J. Wysocki <rjw@rjwysocki.net>
@@ -2458,9 +2458,9 @@ S:	Maintained
 F:	sound/pci/cs5535audio/
 
 CW1200 WLAN driver
-M:     Solomon Peachy <pizza@shaftnet.org>
-S:     Maintained
-F:     drivers/net/wireless/cw1200/
+M:	Solomon Peachy <pizza@shaftnet.org>
+S:	Maintained
+F:	drivers/net/wireless/cw1200/
 
 CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
@@ -5471,11 +5471,11 @@ S:	Maintained
 F:	drivers/media/tuners/m88ts2022*
 
 MA901 MASTERKIT USB FM RADIO DRIVER
-M:      Alexey Klimov <klimov.linux@gmail.com>
-L:      linux-media@vger.kernel.org
-T:      git git://linuxtv.org/media_tree.git
-S:      Maintained
-F:      drivers/media/radio/radio-ma901.c
+M:	Alexey Klimov <klimov.linux@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/radio/radio-ma901.c
 
 MAC80211
 M:	Johannes Berg <johannes@sipsolutions.net>
@@ -5636,7 +5636,7 @@ F:	drivers/scsi/megaraid/
 
 MELLANOX ETHERNET DRIVER (mlx4_en)
 M:	Amir Vadai <amirv@mellanox.com>
-L: 	netdev@vger.kernel.org
+L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
@@ -5678,7 +5678,7 @@ F:	include/linux/mtd/
 F:	include/uapi/mtd/
 
 MEN A21 WATCHDOG DRIVER
-M:  	Johannes Thumshirn <johannes.thumshirn@men.de>
+M:	Johannes Thumshirn <johannes.thumshirn@men.de>
 L:	linux-watchdog@vger.kernel.org
 S:	Supported
 F:	drivers/watchdog/mena21_wdt.c
@@ -5740,14 +5740,14 @@ F:	drivers/net/ethernet/mellanox/mlx5/co
 F:	include/linux/mlx5/
 
 Mellanox MLX5 IB driver
-M:      Eli Cohen <eli@mellanox.com>
-L:      linux-rdma@vger.kernel.org
-W:      http://www.mellanox.com
-Q:      http://patchwork.kernel.org/project/linux-rdma/list/
-T:      git://openfabrics.org/~eli/connect-ib.git
-S:      Supported
-F:      include/linux/mlx5/
-F:      drivers/infiniband/hw/mlx5/
+M:	Eli Cohen <eli@mellanox.com>
+L:	linux-rdma@vger.kernel.org
+W:	http://www.mellanox.com
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
+T:	git://openfabrics.org/~eli/connect-ib.git
+S:	Supported
+F:	include/linux/mlx5/
+F:	drivers/infiniband/hw/mlx5/
 
 MODULE SUPPORT
 M:	Rusty Russell <rusty@rustcorp.com.au>
@@ -8701,17 +8701,17 @@ S:	Maintained
 F:	drivers/media/radio/radio-raremono.c
 
 THERMAL
-M:      Zhang Rui <rui.zhang@intel.com>
-M:      Eduardo Valentin <eduardo.valentin@ti.com>
-L:      linux-pm@vger.kernel.org
-T:      git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
-T:      git git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
-Q:      https://patchwork.kernel.org/project/linux-pm/list/
-S:      Supported
-F:      drivers/thermal/
-F:      include/linux/thermal.h
-F:      include/linux/cpu_cooling.h
-F:      Documentation/devicetree/bindings/thermal/
+M:	Zhang Rui <rui.zhang@intel.com>
+M:	Eduardo Valentin <eduardo.valentin@ti.com>
+L:	linux-pm@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
+Q:	https://patchwork.kernel.org/project/linux-pm/list/
+S:	Supported
+F:	drivers/thermal/
+F:	include/linux/thermal.h
+F:	include/linux/cpu_cooling.h
+F:	Documentation/devicetree/bindings/thermal/
 
 THINGM BLINK(1) USB RGB LED DRIVER
 M:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
errh-use-bool-for-is_err-and-is_err_or_null.patch
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
checkpatch-use-a-more-consistent-function-argument-style.patch
checkpatch-ignore-networking-block-comment-style-first-lines-in-file.patch
checkpatch-make-return-is-not-a-function-test-quieter.patch
checkpatchpl-modify-warning-message-for-printk-usage.patch
ncpfs-add-pr_fmt-and-convert-printks-to-pr_level.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
ncpfs-convert-pprintk-to-ncp_vdbg.patch
ncpfs-remove-now-unused-printk-macro.patch
ncpfs-inode-fix-mismatch-printk-formats-and-arguments.patch
linux-next.patch

