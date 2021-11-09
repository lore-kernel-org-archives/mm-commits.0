Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98206C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F5A61208
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhKICfq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 970D560FDA;
        Tue,  9 Nov 2021 02:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425180;
        bh=dLlmyiXOowsaxSu09ywx9mwMsO0J+JsxyBsXlbgQJkk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CM6xniyrmJF25n583rXPju7HLGZGg8BeLt68XcA9HnpvrwP0sMFJg0UkoXn/ZXn1O
         sVLOXVb1JuCkn62OVpPcIahWVjrY1zdB4KF2xPL4zOXrZsMirDcGicJwwI86yooOyK
         NYetIUXAvTfnGg07Jts6yRm53JIh57EMgQREsnWg=
Date:   Mon, 08 Nov 2021 18:32:59 -0800
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
Subject:  [patch 30/87] MAINTAINERS: rectify entry for HIKEY960
 ONBOARD USB GPIO HUB DRIVER
Message-ID: <20211109023259.gBt4QkbIV%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: rectify entry for HIKEY960 ONBOARD USB GPIO HUB DRIVER

Commit 7a6ff4c4cbc3 ("misc: hisi_hikey_usb: Driver to support onboard USB
gpio hub on Hikey960") refers to the non-existing file
./Documentation/devicetree/bindings/misc/hisilicon-hikey-usb.yaml, but
this commit's patch series does not add any related devicetree binding in
misc.

So, just drop this file reference in HIKEY960 ONBOARD USB GPIO HUB DRIVER.

Link: https://lkml.kernel.org/r/20211026141902.4865-3-lukas.bulwahn@gmail.com
Fixes: 7a6ff4c4cbc3 ("misc: hisi_hikey_usb: Driver to support onboard USB gpio hub on Hikey960")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Cc: Edmund Dea <edmund.j.dea@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc: Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Cc: Yu Chen <chenyu56@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-rectify-entry-for-hikey960-onboard-usb-gpio-hub-driver
+++ a/MAINTAINERS
@@ -8483,7 +8483,6 @@ M:	John Stultz <john.stultz@linaro.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/hisi_hikey_usb.c
-F:	Documentation/devicetree/bindings/misc/hisilicon-hikey-usb.yaml
 
 HISILICON PMU DRIVER
 M:	Shaokun Zhang <zhangshaokun@hisilicon.com>
_
