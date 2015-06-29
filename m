From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-quotation-marks-around-names-with-periods.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:47:46 -0700
Message-ID: <5591aef2.dXODyUtq01RwDQV6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbbF2Urr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add quotation marks around names with periods
has been removed from the -mm tree.  Its filename was
     maintainers-add-quotation-marks-around-names-with-periods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: add quotation marks around names with periods

This makes it easier to copy/paste names with periods to email clients.

All the other names with periods already have quotation marks.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN MAINTAINERS~maintainers-add-quotation-marks-around-names-with-periods MAINTAINERS
--- a/MAINTAINERS~maintainers-add-quotation-marks-around-names-with-periods
+++ a/MAINTAINERS
@@ -259,7 +259,7 @@ S:	Maintained
 F:	drivers/platform/x86/acer-wmi.c
 
 ACPI
-M:	Rafael J. Wysocki <rjw@rjwysocki.net>
+M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 M:	Len Brown <lenb@kernel.org>
 L:	linux-acpi@vger.kernel.org
 W:	https://01.org/linux-acpi
@@ -280,7 +280,7 @@ F:	tools/power/acpi/
 ACPI COMPONENT ARCHITECTURE (ACPICA)
 M:	Robert Moore <robert.moore@intel.com>
 M:	Lv Zheng <lv.zheng@intel.com>
-M:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+M:	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
 L:	linux-acpi@vger.kernel.org
 L:	devel@acpica.org
 W:	https://acpica.org/
@@ -2804,7 +2804,7 @@ S:	Maintained
 F:	drivers/net/ethernet/ti/cpmac.c
 
 CPU FREQUENCY DRIVERS
-M:	Rafael J. Wysocki <rjw@rjwysocki.net>
+M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 M:	Viresh Kumar <viresh.kumar@linaro.org>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
@@ -2843,7 +2843,7 @@ F:	drivers/cpuidle/cpuidle-exynos.c
 F:	arch/arm/mach-exynos/pm.c
 
 CPUIDLE DRIVERS
-M:	Rafael J. Wysocki <rjw@rjwysocki.net>
+M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
 M:	Daniel Lezcano <daniel.lezcano@linaro.org>
 L:	linux-pm@vger.kernel.org
 S:	Maintained
@@ -4059,7 +4059,7 @@ F:	include/uapi/scsi/fc/
 
 FILE LOCKING (flock() and fcntl()/lockf())
 M:	Jeff Layton <jlayton@poochiereds.net>
-M:	J. Bruce Fields <bfields@fieldses.org>
+M:	"J. Bruce Fields" <bfields@fieldses.org>
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	include/linux/fcntl.h
@@ -4255,7 +4255,7 @@ F:	sound/soc/fsl/imx*
 F:	sound/soc/fsl/mpc8610_hpcd.c
 
 FREESCALE QORIQ MANAGEMENT COMPLEX DRIVER
-M:	J. German Rivera <German.Rivera@freescale.com>
+M:	"J. German Rivera" <German.Rivera@freescale.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/staging/fsl-mc/
@@ -4816,7 +4816,7 @@ S:	Maintained
 F:	fs/hugetlbfs/
 
 Hyper-V CORE AND DRIVERS
-M:	K. Y. Srinivasan <kys@microsoft.com>
+M:	"K. Y. Srinivasan" <kys@microsoft.com>
 M:	Haiyang Zhang <haiyangz@microsoft.com>
 L:	devel@linuxdriverproject.org
 S:	Maintained
@@ -7881,7 +7881,7 @@ F:	include/linux/power_supply.h
 F:	drivers/power/
 
 PNP SUPPORT
-M:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+M:	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
 S:	Maintained
 F:	drivers/pnp/
 
@@ -8885,7 +8885,7 @@ F:	drivers/mmc/host/sdhci-spear.c
 
 SECURITY SUBSYSTEM
 M:	James Morris <james.l.morris@oracle.com>
-M:	Serge E. Hallyn <serge@hallyn.com>
+M:	"Serge E. Hallyn" <serge@hallyn.com>
 L:	linux-security-module@vger.kernel.org (suggested Cc:)
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
 W:	http://kernsec.org/
@@ -9689,7 +9689,7 @@ F:	fs/sysv/
 F:	include/linux/sysv_fs.h
 
 TARGET SUBSYSTEM
-M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
+M:	"Nicholas A. Bellinger" <nab@linux-iscsi.org>
 L:	linux-scsi@vger.kernel.org
 L:	target-devel@vger.kernel.org
 W:	http://www.linux-iscsi.org
@@ -9831,7 +9831,7 @@ F:	include/linux/if_team.h
 F:	include/uapi/linux/if_team.h
 
 TECHNOLOGIC SYSTEMS TS-5500 PLATFORM SUPPORT
-M:	Savoir-faire Linux Inc. <kernel@savoirfairelinux.com>
+M:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
 S:	Maintained
 F:	arch/x86/platform/ts5500/
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

