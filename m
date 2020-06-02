From: akpm@linux-foundation.org
Subject: + sh-drop-config_mtd_m25p80-in-sh7757lcr_defconfig.patch
 added to -mm tree
Date: Mon, 01 Jun 2020 17:55:27 -0700
Message-ID: <20200602005527.7GpzTDPWe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBAz3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 20:55:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: drop CONFIG_MTD_M25P80 in sh7757lcr_defconfig
has been added to the -mm tree.  Its filename is
     sh-drop-config_mtd_m25p80-in-sh7757lcr_defconfig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-drop-config_mtd_m25p80-in-sh7757lcr_defconfig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-drop-config_mtd_m25p80-in-sh7757lcr_defconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bin Meng <bin.meng@windriver.com>
Subject: sh: drop CONFIG_MTD_M25P80 in sh7757lcr_defconfig

Drop CONFIG_MTD_M25P80 that was removed in commit b35b9a10362d ("mtd:
spi-nor: Move m25p80 code in spi-nor.c")

Signed-off-by: Bin Meng <bin.meng@windriver.com>
Cc: Alan Modra <amodra@gmail.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/configs/sh7757lcr_defconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/sh/configs/sh7757lcr_defconfig~sh-drop-config_mtd_m25p80-in-sh7757lcr_defconfig
+++ a/arch/sh/configs/sh7757lcr_defconfig
@@ -36,7 +36,6 @@ CONFIG_IPV6=y
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_BLOCK=y
-CONFIG_MTD_M25P80=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
_

Patches currently in -mm which might be from bin.meng@windriver.com are

sh-drop-config_mtd_m25p80-in-sh7757lcr_defconfig.patch
