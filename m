Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71224C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5911A610CB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbhJ0IIZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240718AbhJ0IIT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 04:08:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E75D960C40;
        Wed, 27 Oct 2021 08:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635321954;
        bh=tiTYt0isk4aCpDWxERbChWOw0HZ1DxuU06kcEgZrtus=;
        h=Date:From:To:Subject:From;
        b=F8xLAq2RmmwmhHFSweCSlKZWfAGME3M+ipQZUBWqueNI6/s2B34gVF8V1U0u9Zo6s
         OOCcmjSJf5J0Nt7CMJckvk04nJuHXs1GEtikMTxlXGxBq3iSM/mtGz0fcvM/s06HKh
         3jq9BmiYvow3yF2aT6qBtSWbP8eWElz13nos6SrQ=
Date:   Wed, 27 Oct 2021 01:05:53 -0700
From:   akpm@linux-foundation.org
To:     anitha.chrisanthus@intel.com, chenyu56@huawei.com,
        edmund.j.dea@intel.com, gregkh@linuxfoundation.org,
        joe@perches.com, john.stultz@linaro.org, lukas.bulwahn@gmail.com,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, punit1.agrawal@toshiba.co.jp,
        ralf.ramsauer@oth-regensburg.de, robh+dt@kernel.org,
        sam@ravnborg.org, wilken.gottwalt@posteo.net
Subject:  +
 maintainers-rectify-entry-for-hikey960-onboard-usb-gpio-hub-driver.patch
 added to -mm tree
Message-ID: <20211027080553.Q0lU6y6Fw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: rectify entry for HIKEY960 ONBOARD USB GPIO HUB DRIVER
has been added to the -mm tree.  Its filename is
     maintainers-rectify-entry-for-hikey960-onboard-usb-gpio-hub-driver.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-rectify-entry-for-hikey960-onboard-usb-gpio-hub-driver.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-rectify-entry-for-hikey960-onboard-usb-gpio-hub-driver.patch

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
@@ -8471,7 +8471,6 @@ M:	John Stultz <john.stultz@linaro.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/misc/hisi_hikey_usb.c
-F:	Documentation/devicetree/bindings/misc/hisilicon-hikey-usb.yaml
 
 HISILICON PMU DRIVER
 M:	Shaokun Zhang <zhangshaokun@hisilicon.com>
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

memory-remove-unused-config_mem_block_size.patch
maintainers-rectify-entry-for-arm-toshiba-visconti-architecture.patch
maintainers-rectify-entry-for-hikey960-onboard-usb-gpio-hub-driver.patch
maintainers-rectify-entry-for-intel-keem-bay-drm-driver.patch
maintainers-rectify-entry-for-allwinner-hardware-spinlock-support.patch

