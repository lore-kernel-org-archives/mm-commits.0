Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C716C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 18:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 668F120738
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 18:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598295373;
	bh=UpGhHk6URCRrm0oGr3eMFtnWkRh6MXKLCo/Km7SHWZ0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qoF7cALTY9bwa+na7uk7OVOTfYE+PKwI6lJ4FcL3iXSaBIEN7bnF+vvmECJyyozLd
	 CZLKpcX8Y8Q12k7XI0LIe9vPMtYaSEJtpEJzqK1bzM56nAk6aEbaOIe3Cmm4UVDHRw
	 5FqZL2ydjxjyb24XqUeW5ZJAewOwbQ//KsaJp1gQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHXS4N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 14:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgHXS4M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 14:56:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A29F3206BE;
        Mon, 24 Aug 2020 18:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598295371;
        bh=UpGhHk6URCRrm0oGr3eMFtnWkRh6MXKLCo/Km7SHWZ0=;
        h=Date:From:To:Subject:From;
        b=z+0O6QdSJZGzSHMk06kH6keLMNtfz0dZgNRCk3P+6MSwigJ9DWTTQ4l9Wd27BGA5f
         tq43gVjeUnCK37yN9UXngXhjjaOuYzvnNofSJvFR6CB+9UfYLi04eeDT7QRNohjOip
         LzVWnZI93OHKCsJKaSXomwcDm++tsvC5Xu7h44zM=
Date:   Mon, 24 Aug 2020 11:56:10 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, bp@alien8.de, gkulkarni@marvell.com, maz@kernel.org,
        mm-commits@vger.kernel.org, rric@kernel.org, sgoutham@marvell.com,
        wsa@kernel.org
Subject:  + maintainers-update-cavium-marvell-entries.patch added
 to -mm tree
Message-ID: <20200824185610.BFXs08uSm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Cavium/Marvell entries
has been added to the -mm tree.  Its filename is
     maintainers-update-cavium-marvell-entries.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-cavium-marvell-entries.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-cavium-marvell-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -3931,8 +3930,8 @@ W:	https://wireless.wiki.kernel.org/en/u
 F:	drivers/net/wireless/ath/carl9170/
 
 CAVIUM I2C DRIVER
-M:	Robert Richter <rrichter@marvell.com>
-S:	Supported
+M:	Robert Richter <rric@kernel.org>
+S:	Odd Fixes
 W:	http://www.marvell.com
 F:	drivers/i2c/busses/i2c-octeon*
 F:	drivers/i2c/busses/i2c-thunderx*
@@ -3947,8 +3946,8 @@ W:	http://www.marvell.com
 F:	drivers/net/ethernet/cavium/liquidio/
 
 CAVIUM MMC DRIVER
-M:	Robert Richter <rrichter@marvell.com>
-S:	Supported
+M:	Robert Richter <rric@kernel.org>
+S:	Odd Fixes
 W:	http://www.marvell.com
 F:	drivers/mmc/host/cavium*
 
@@ -3960,9 +3959,9 @@ W:	http://www.marvell.com
 F:	drivers/crypto/cavium/cpt/
 
 CAVIUM THUNDERX2 ARM64 SOC
-M:	Robert Richter <rrichter@marvell.com>
+M:	Robert Richter <rric@kernel.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-S:	Maintained
+S:	Odd Fixes
 F:	Documentation/devicetree/bindings/arm/cavium-thunder2.txt
 F:	arch/arm64/boot/dts/cavium/thunder2-99xx*
 
@@ -6173,16 +6172,15 @@ F:	drivers/edac/highbank*
 
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
@@ -6190,7 +6188,7 @@ M:	Borislav Petkov <bp@alien8.de>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
 M:	Tony Luck <tony.luck@intel.com>
 R:	James Morse <james.morse@arm.com>
-R:	Robert Richter <rrichter@marvell.com>
+R:	Robert Richter <rric@kernel.org>
 L:	linux-edac@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git edac-for-next
@@ -13429,10 +13427,10 @@ F:	Documentation/devicetree/bindings/pci
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
@@ -17214,8 +17212,8 @@ S:	Maintained
 F:	drivers/net/thunderbolt.c
 
 THUNDERX GPIO DRIVER
-M:	Robert Richter <rrichter@marvell.com>
-S:	Maintained
+M:	Robert Richter <rric@kernel.org>
+S:	Odd Fixes
 F:	drivers/gpio/gpio-thunderx.c
 
 TI AM437X VPFE DRIVER
_

Patches currently in -mm which might be from rric@kernel.org are

maintainers-update-cavium-marvell-entries.patch

