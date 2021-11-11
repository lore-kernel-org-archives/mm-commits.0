Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF7AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D15E610A2
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbhKKCyq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCyp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA57560F26;
        Thu, 11 Nov 2021 02:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599117;
        bh=+dSQHbIwaHvcljBKzA6anx9tbKCs0INOIYlgz9xY6co=;
        h=Date:From:To:Subject:From;
        b=b83gjkoG6ipBf1OLxlTVXYSSE8T4YGN2iu15DmqkdHWzUw5iezZ9a9ZRpACZ9vDgf
         WJSLIEf5kKyFVA9MISIzetljafFm4Y4B6OuE1kJz1xVUGrC3y7py033qAYk/Uwc6h7
         otC2yiYUn6eq7OPgmxbhd4FuN6JkWdzD7kuIAjcA=
Date:   Wed, 10 Nov 2021 18:51:56 -0800
From:   akpm@linux-foundation.org
To:     anitha.chrisanthus@intel.com, chenyu56@huawei.com,
        edmund.j.dea@intel.com, gregkh@linuxfoundation.org,
        joe@perches.com, john.stultz@linaro.org, lukas.bulwahn@gmail.com,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, punit1.agrawal@toshiba.co.jp,
        ralf.ramsauer@oth-regensburg.de, robh+dt@kernel.org,
        sam@ravnborg.org, wilken.gottwalt@posteo.net
Subject:  [merged]
 maintainers-rectify-entry-for-arm-toshiba-visconti-architecture.patch
 removed from -mm tree
Message-ID: <20211111025156.lCIZU2uYz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: rectify entry for ARM/TOSHIBA VISCONTI ARCHITECTURE
has been removed from the -mm tree.  Its filename was
     maintainers-rectify-entry-for-arm-toshiba-visconti-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


