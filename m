Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB534C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E3261242
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbhKICfm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 281DB6120A;
        Tue,  9 Nov 2021 02:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425176;
        bh=+xiUqjwGGw/j5jc3FZylmkmGj+YqkHiejjeD+HnfuLA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UXGTdxUEnsa0xTfGwbTOZ5LJ7MpwVrwOz2Mc1/vuQsdiAKdfa6hNr35wShHcdsHZs
         Asagmax+HL/N0SHYG9TWJEIbev24RHnoAczH7Omw15s6UN+8STDOhgwJfLmBlIBWmK
         3bPnLjTiuU2Gd8o3Je8nEyj04vtOVqP7+2Hws4bw=
Date:   Mon, 08 Nov 2021 18:32:55 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anitha.chrisanthus@intel.com,
        chenyu56@huawei.com, edmund.j.dea@intel.com,
        gregkh@linuxfoundation.org, joe@perches.com,
        john.stultz@linaro.org, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp,
        punit1.agrawal@toshiba.co.jp, ralf.ramsauer@oth-regensburg.de,
        robh+dt@kernel.org, sam@ravnborg.org,
        torvalds@linux-foundation.org, wilken.gottwalt@posteo.net
Subject:  [patch 29/87] MAINTAINERS: rectify entry for ARM/TOSHIBA
 VISCONTI ARCHITECTURE
Message-ID: <20211109023255.MBGewaUVn%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
