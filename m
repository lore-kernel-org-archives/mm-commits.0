From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-use-correct-filename-for-sdhci-bcm-kona.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:43:13 -0700
Message-ID: <53ea6e51.K4OB4x1wKRj2hsd5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:36599 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaHLTnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:16 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so1920661oah.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, csd@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: use correct filename for sdhci-bcm-kona
has been removed from the -mm tree.  Its filename was
     maintainers-use-correct-filename-for-sdhci-bcm-kona.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: use correct filename for sdhci-bcm-kona

Use dashes not underscores.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christian Daudt <csd@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-use-correct-filename-for-sdhci-bcm-kona MAINTAINERS
--- a/MAINTAINERS~maintainers-use-correct-filename-for-sdhci-bcm-kona
+++ a/MAINTAINERS
@@ -1983,7 +1983,7 @@ F:	arch/arm/boot/dts/bcm113*
 F:	arch/arm/boot/dts/bcm216*
 F:	arch/arm/boot/dts/bcm281*
 F:	arch/arm/configs/bcm_defconfig
-F:	drivers/mmc/host/sdhci_bcm_kona.c
+F:	drivers/mmc/host/sdhci-bcm-kona.c
 F:	drivers/clocksource/bcm_kona_timer.c
 
 BROADCOM BCM2835 ARM ARCHICTURE
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

