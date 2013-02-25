From: akpm@linux-foundation.org
Subject: + maintainers-update-tegra-section-to-capture-all-tegra-files.patch added to -mm tree
Date: Mon, 25 Feb 2013 13:35:53 -0800
Message-ID: <20130225213553.CB12B5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:55002 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab3BYVfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 16:35:55 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so164895yen.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 13:35:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: swarren@nvidia.com, jak@jak-linux.org, joe@perches.com, marvin24@gmx.de


The patch titled
     Subject: MAINTAINERS: update Tegra section to capture all Tegra files
has been added to the -mm tree.  Its filename is
     maintainers-update-tegra-section-to-capture-all-tegra-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -7559,6 +7559,7 @@ STAGING - NVIDIA COMPLIANT EMBEDDED CONT
 M:	Julian Andres Klode <jak@jak-linux.org>
 M:	Marc Dietrich <marvin24@gmx.de>
 L:	ac100@lists.launchpad.net (moderated for non-subscribers)
+L:	linux-tegra@vger.kernel.org
 S:	Maintained
 F:	drivers/staging/nvec/
 
@@ -7857,9 +7858,7 @@ L:	linux-tegra@vger.kernel.org
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
get_maintainer-allow-keywords-to-match-filenames.patch
maintainers-update-tegra-section-to-capture-all-tegra-files.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch

