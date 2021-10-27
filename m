Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE93C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FF6A610A5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbhJ0IIR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:08:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240767AbhJ0IIQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 04:08:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2145260F22;
        Wed, 27 Oct 2021 08:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635321951;
        bh=rnZlt24iKTGsivYR2/COdojFdIGigqgcIo2c3wvX3O4=;
        h=Date:From:To:Subject:From;
        b=bU4v0nBP89M1XNzT6L2ZtuNjKtSIY4/5fjmLYXsarfU114/rBRXyBXNOcPPPwbDwp
         7zS08QSNeuQBYTXDZEXFeSscPhl63N1m2DZmuVpoROdTIE1rb2/jIsGtqrO9ow4xxz
         afAdrmwLvG1RV1hQJpp1DaJPBxd346HyVq/vVFnk=
Date:   Wed, 27 Oct 2021 01:05:50 -0700
From:   akpm@linux-foundation.org
To:     anitha.chrisanthus@intel.com, chenyu56@huawei.com,
        edmund.j.dea@intel.com, gregkh@linuxfoundation.org,
        joe@perches.com, john.stultz@linaro.org, lukas.bulwahn@gmail.com,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, punit1.agrawal@toshiba.co.jp,
        ralf.ramsauer@oth-regensburg.de, robh+dt@kernel.org,
        sam@ravnborg.org, wilken.gottwalt@posteo.net
Subject:  +
 maintainers-rectify-entry-for-arm-toshiba-visconti-architecture.patch added
 to -mm tree
Message-ID: <20211027080550.1wbUe5wvY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: rectify entry for ARM/TOSHIBA VISCONTI ARCHITECTURE
has been added to the -mm tree.  Its filename is
     maintainers-rectify-entry-for-arm-toshiba-visconti-architecture.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-rectify-entry-for-arm-toshiba-visconti-architecture.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-rectify-entry-for-arm-toshiba-visconti-architecture.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: rectify entry for ARM/TOSHIBA VISCONTI ARCHITECTURE

Patch series "Rectify file references for dt-bindings in MAINTAINERS", v5.

A patch series that cleans up some file references for dt-bindings in
MAINTAINERS.  


This patch (of 4):

Commit 836863a08c99 ("MAINTAINERS: Add information for Toshiba Visconti
ARM SoCs") refers to the non-existing file toshiba,tmpv7700-pinctrl.yaml
in ./Documentation/devicetree/bindings/pinctrl/.  Commit 1825c1fe0057
("pinctrl: Add DT bindings for Toshiba Visconti TMPV7700 SoC") originating
from the same patch series however adds the file
toshiba,visconti-pinctrl.yaml in that directory instead.

So, refer to toshiba,visconti-pinctrl.yaml in the ARM/TOSHIBA VISCONTI
ARCHITECTURE section instead.

Link: https://lkml.kernel.org/r/20211026141902.4865-1-lukas.bulwahn@gmail.com
Link: https://lkml.kernel.org/r/20211026141902.4865-2-lukas.bulwahn@gmail.com
Fixes: 836863a08c99 ("MAINTAINERS: Add information for Toshiba Visconti ARM SoCs")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Cc: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Yu Chen <chenyu56@huawei.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Edmund Dea <edmund.j.dea@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-rectify-entry-for-arm-toshiba-visconti-architecture
+++ a/MAINTAINERS
@@ -2745,7 +2745,7 @@ F:	Documentation/devicetree/bindings/arm
 F:	Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
 F:	Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
 F:	Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml
-F:	Documentation/devicetree/bindings/pinctrl/toshiba,tmpv7700-pinctrl.yaml
+F:	Documentation/devicetree/bindings/pinctrl/toshiba,visconti-pinctrl.yaml
 F:	Documentation/devicetree/bindings/watchdog/toshiba,visconti-wdt.yaml
 F:	arch/arm64/boot/dts/toshiba/
 F:	drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

memory-remove-unused-config_mem_block_size.patch
maintainers-rectify-entry-for-arm-toshiba-visconti-architecture.patch
maintainers-rectify-entry-for-hikey960-onboard-usb-gpio-hub-driver.patch
maintainers-rectify-entry-for-intel-keem-bay-drm-driver.patch
maintainers-rectify-entry-for-allwinner-hardware-spinlock-support.patch

