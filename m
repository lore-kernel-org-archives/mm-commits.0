Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802DEC43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FA3C20FC3
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262537;
	bh=smVLCpEwhOSUgfLafO/OyOY1TMDbB6uY/3OJ5tmzMcw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zAIAb3wWGMJ4bftgapLU+sTBvKhdLEY17I9//M6YKA2gnhgeILq1+Tbe4gKhtB5Fr
	 FJzZfz+4X9+hN1macwecCfS+esb0AyrGo7KHyyw9Kl1oMEqCYYK6143cAaxy6wRgus
	 Zb69AEFD6qFxxNSHzD48l+/wnX7D8sfqqnmmS2Y0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgIDXfh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXff (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:35:35 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25ECA2084D;
        Fri,  4 Sep 2020 23:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262534;
        bh=smVLCpEwhOSUgfLafO/OyOY1TMDbB6uY/3OJ5tmzMcw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BlLw/GV/N3OaMe8Z9Ph5mQbjRJqbXptjnsgIkWauw21UKI0s4rj9nWKb1yyRwMQ4/
         FiCmYknkZqLc5xQ+bFPp6fiJ6adhdrg3ZrFjhNeDqN6+7CuF868roosTqAS7OjoLXc
         Ku8MMi5RPC+9ltIQg48f8jnoXOqyHu645dogkecI=
Date:   Fri, 04 Sep 2020 16:35:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de,
        gkulkarni@marvell.com, linux-mm@kvack.org, maz@kernel.org,
        mm-commits@vger.kernel.org, rric@kernel.org, sgoutham@marvell.com,
        torvalds@linux-foundation.org, wsa@kernel.org
Subject:  [patch 04/19] MAINTAINERS: update Cavium/Marvell entries
Message-ID: <20200904233533.UMtJ_QFkU%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Robert Richter <rric@kernel.org>
Subject: MAINTAINERS: update Cavium/Marvell entries

I am leaving Marvell and already do not have access to my @marvell.com
email address.  So switching over to my korg mail address or removing my
address there another maintainer is already listed.  For the entries there
no other maintainer is listed I will keep looking into patches for Cavium
systems for a while until someone from Marvell takes it over.  Since I
might have limited access to hardware and also limited time I changed
state to 'Odd Fixes' for those entries.

Link: https://lkml.kernel.org/r/20200824122050.31164-1-rric@kernel.org
Signed-off-by: Robert Richter <rric@kernel.org>
Cc: Ganapatrao Kulkarni <gkulkarni@marvell.com>
Cc: Sunil Goutham <sgoutham@marvell.com>
CC: Borislav Petkov <bp@alien8.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Wolfram Sang <wsa@kernel.org>, 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/MAINTAINERS~maintainers-update-cavium-marvell-entries
+++ a/MAINTAINERS
@@ -1694,7 +1694,6 @@ F:	arch/arm/mach-cns3xxx/
 
 ARM/CAVIUM THUNDER NETWORK DRIVER
 M:	Sunil Goutham <sgoutham@marvell.com>
-M:	Robert Richter <rrichter@marvell.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	drivers/net/ethernet/cavium/thunder/
@@ -3948,8 +3947,8 @@ W:	https://wireless.wiki.kernel.org/en/u
 F:	drivers/net/wireless/ath/carl9170/
 
 CAVIUM I2C DRIVER
-M:	Robert Richter <rrichter@marvell.com>
-S:	Supported
+M:	Robert Richter <rric@kernel.org>
+S:	Odd Fixes
 W:	http://www.marvell.com
 F:	drivers/i2c/busses/i2c-octeon*
 F:	drivers/i2c/busses/i2c-thunderx*
@@ -3964,8 +3963,8 @@ W:	http://www.marvell.com
 F:	drivers/net/ethernet/cavium/liquidio/
 
 CAVIUM MMC DRIVER
-M:	Robert Richter <rrichter@marvell.com>
-S:	Supported
+M:	Robert Richter <rric@kernel.org>
+S:	Odd Fixes
 W:	http://www.marvell.com
 F:	drivers/mmc/host/cavium*
 
@@ -3977,9 +3976,9 @@ W:	http://www.marvell.com
 F:	drivers/crypto/cavium/cpt/
 
 CAVIUM THUNDERX2 ARM64 SOC
-M:	Robert Richter <rrichter@marvell.com>
+M:	Robert Richter <rric@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
+S:	Odd Fixes
 F:	Documentation/devicetree/bindings/arm/cavium-thunder2.txt
 F:	arch/arm64/boot/dts/cavium/thunder2-99xx*
 
@@ -6191,16 +6190,15 @@ F:	drivers/edac/highbank*
 
 EDAC-CAVIUM OCTEON
 M:	Ralf Baechle <ralf@linux-mips.org>
-M:	Robert Richter <rrichter@marvell.com>
 L:	linux-edac@vger.kernel.org
 L:	linux-mips@vger.kernel.org
 S:	Supported
 F:	drivers/edac/octeon_edac*
 
 EDAC-CAVIUM THUNDERX
-M:	Robert Richter <rrichter@marvell.com>
+M:	Robert Richter <rric@kernel.org>
 L:	linux-edac@vger.kernel.org
-S:	Supported
+S:	Odd Fixes
 F:	drivers/edac/thunderx_edac*
 
 EDAC-CORE
@@ -6208,7 +6206,7 @@ M:	Borislav Petkov <bp@alien8.de>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 M:	Tony Luck <tony.luck@intel.com>
 R:	James Morse <james.morse@arm.com>
-R:	Robert Richter <rrichter@marvell.com>
+R:	Robert Richter <rric@kernel.org>
 L:	linux-edac@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git edac-for-next
@@ -13446,10 +13444,10 @@ F:	Documentation/devicetree/bindings/pci
 F:	drivers/pci/controller/dwc/*artpec*
 
 PCIE DRIVER FOR CAVIUM THUNDERX
-M:	Robert Richter <rrichter@marvell.com>
+M:	Robert Richter <rric@kernel.org>
 L:	linux-pci@vger.kernel.org
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Supported
+S:	Odd Fixes
 F:	drivers/pci/controller/pci-thunder-*
 
 PCIE DRIVER FOR HISILICON
@@ -17237,8 +17235,8 @@ S:	Maintained
 F:	drivers/net/thunderbolt.c
 
 THUNDERX GPIO DRIVER
-M:	Robert Richter <rrichter@marvell.com>
-S:	Maintained
+M:	Robert Richter <rric@kernel.org>
+S:	Odd Fixes
 F:	drivers/gpio/gpio-thunderx.c
 
 TI AM437X VPFE DRIVER
_
