From: akpm@linux-foundation.org
Subject: [merged] rtc-efi-add-missing-module-alias.patch removed from -mm
 tree
Date: Mon, 29 Sep 2014 13:22:30 -0700
Message-ID: <5429bf86.TJwusdEUpheeFKDY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaI2UWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Sep 2014 16:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pali.rohar@gmail.com, a.zummo@towertech.it, dannf@dannf.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-efi.c: add missing module alias
has been removed from the -mm tree.  Its filename was
     rtc-efi-add-missing-module-alias.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Pali Roh=E1r <pali.rohar@gmail.com>
Subject: drivers/rtc/rtc-efi.c: add missing module alias

Without proper alias kernel module is not loaded for rtc-efi driver.

Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
Cc: dann frazier <dannf@dannf.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-efi.c~rtc-efi-add-missing-module-alias driver=
s/rtc/rtc-efi.c
--- a/drivers/rtc/rtc-efi.c~rtc-efi-add-missing-module-alias
+++ a/drivers/rtc/rtc-efi.c
@@ -232,6 +232,7 @@ static struct platform_driver efi_rtc_dr
=20
 module_platform_driver_probe(efi_rtc_driver, efi_rtc_probe);
=20
+MODULE_ALIAS("platform:rtc-efi");
 MODULE_AUTHOR("dann frazier <dannf@hp.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("EFI RTC driver");
_

Patches currently in -mm which might be from pali.rohar@gmail.com are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
