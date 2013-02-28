From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-tegra-section-to-capture-all-tegra-files.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:56 -0800
Message-ID: <20130228201056.BF2CA31C211@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:39345 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab3B1UK6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:58 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so244499ves.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: swarren@nvidia.com, jak@jak-linux.org, joe@perches.com, marvin24@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Tegra section to capture all Tegra files
has been removed from the -mm tree.  Its filename was
     maintainers-update-tegra-section-to-capture-all-tegra-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Warren <swarren@nvidia.com>
Subject: MAINTAINERS: update Tegra section to capture all Tegra files

The intent is to ensure that all Tegra-related patches are sent to the
linux-tegra@ mailing list, so people can keep up-to-date on all misc
driver changes.

Doing this with a keyword is far simpler and more compact than listing all
Tegra-related drivers, even if wildcards were used.

Words such as integrate or integrator are common.  Ensure the character
right before "tegra" isn't a-z (case-insensitive), to make sure the
keyword doesn't match those.

The only files that the keyword doesn't match are the NVEC driver.  Add
the linux-tegra mailing list to the NVEC entry to solve this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Cc: Joe Perches <joe@perches.com>
Cc: Julian Andres Klode <jak@jak-linux.org>
Cc: Marc Dietrich <marvin24@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-tegra-section-to-capture-all-tegra-files MAINTAINERS
--- a/MAINTAINERS~maintainers-update-tegra-section-to-capture-all-tegra-files
+++ a/MAINTAINERS
@@ -7540,6 +7540,7 @@ STAGING - NVIDIA COMPLIANT EMBEDDED CONT
 M:	Julian Andres Klode <jak@jak-linux.org>
 M:	Marc Dietrich <marvin24@gmx.de>
 L:	ac100@lists.launchpad.net (moderated for non-subscribers)
+L:	linux-tegra@vger.kernel.org
 S:	Maintained
 F:	drivers/staging/nvec/
 
@@ -7832,9 +7833,7 @@ L:	linux-tegra@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
 S:	Supported
-F:	arch/arm/mach-tegra
-F:	arch/arm/boot/dts/tegra*
-F:	arch/arm/configs/tegra_defconfig
+K:	(?i)[^a-z]tegra
 
 TEHUTI ETHERNET DRIVER
 M:	Andy Gospodarek <andy@greyhouse.net>
_

Patches currently in -mm which might be from swarren@nvidia.com are

origin.patch
linux-next.patch

