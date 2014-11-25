From: akpm@linux-foundation.org
Subject: + of-add-vendor-prefix-for-pericom-technology.patch added to -mm
 tree
Date: Mon, 24 Nov 2014 22:42:49 -0800
Message-ID: <547424e9.5MttrzLPO/0/YnH7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaKYGm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 01:42:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomas@novotny.cz, a.zummo@towertech.it, grant.likely@linaro.org, robh+dt@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: of: add vendor prefix for Pericom Technology
has been added to the -mm tree.  Its filename is
     of-add-vendor-prefix-for-pericom-technology.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/of-add-vendor-prefix-for-pericom-technology.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/of-add-vendor-prefix-for-pericom-technology.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tomas Novotny <tomas@novotny.cz>
Subject: of: add vendor prefix for Pericom Technology

Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/vendor-prefixes.txt |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/devicetree/bindings/vendor-prefixes.txt~of-add-vendor-prefix-for-pericom-technology Documentation/devicetree/bindings/vendor-prefixes.txt
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt~of-add-vendor-prefix-for-pericom-technology
+++ a/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -112,6 +112,7 @@ nxp	NXP Semiconductors
 onnn	ON Semiconductor Corp.
 opencores	OpenCores.org
 panasonic	Panasonic Corporation
+pericom	Pericom Technology Inc.
 phytec	PHYTEC Messtechnik GmbH
 picochip	Picochip Ltd
 plathome	Plat'Home Co., Ltd.
_

Patches currently in -mm which might be from tomas@novotny.cz are

rtc-ds1307-add-support-for-mcp7940x-chips.patch
of-add-vendor-prefix-for-pericom-technology.patch
rtc-ds1307-add-device-tree-bindings-documentation.patch
rtc-ds1307-add-device-tree-support.patch

