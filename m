From: akpm@linux-foundation.org
Subject: + maintainers-add-mediatek-soc-mailing-list.patch added to -mm
 tree
Date: Wed, 11 Mar 2015 14:00:37 -0700
Message-ID: <5500acf5.+hz7s2iOkiDep9xH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbCKVAi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 17:00:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.bgg@gmail.com, arnd@arndb.de, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Mediatek SoC mailing list
has been added to the -mm tree.  Its filename is
     maintainers-add-mediatek-soc-mailing-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-add-mediatek-soc-mailing-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-add-mediatek-soc-mailing-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthias Brugger <matthias.bgg@gmail.com>
Subject: MAINTAINERS: add Mediatek SoC mailing list

Add the new list that Mediatek specific patches should also be
directed to.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-mediatek-soc-mailing-list MAINTAINERS
--- a/MAINTAINERS~maintainers-add-mediatek-soc-mailing-list
+++ a/MAINTAINERS
@@ -1211,6 +1211,7 @@ F:	arch/arm/mach-orion5x/ts78xx-*
 ARM/Mediatek SoC support
 M:	Matthias Brugger <matthias.bgg@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm/boot/dts/mt6*
 F:	arch/arm/boot/dts/mt8*
_

Patches currently in -mm which might be from matthias.bgg@gmail.com are

rtc-mediatek-add-mt63xx-rtc-driver.patch
maintainers-add-mediatek-soc-mailing-list.patch

