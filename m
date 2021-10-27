Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A249DC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 847B9610CB
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbhJ0II0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239236AbhJ0IIW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 04:08:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F27C661075;
        Wed, 27 Oct 2021 08:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635321957;
        bh=iWhthtDmp6gnLsc1iauQssod61FhsDqVB5fHikOozhg=;
        h=Date:From:To:Subject:From;
        b=OerR3kbMEGjWBTytG3lNmzzf5+bkOTLUfBHBpIfgJyE4xf39l8HtlMnPOs2iGH08Y
         XsSWRle/MXFfdceAhmWhqE7DKGr8IOHuEpFoBzLot1uDNjXZHJXAgkVFF6JPX4ShtK
         u0tk4Rc+kT05tcsh/SfzsQdIEsFgrunDppu5xMEI=
Date:   Wed, 27 Oct 2021 01:05:56 -0700
From:   akpm@linux-foundation.org
To:     anitha.chrisanthus@intel.com, chenyu56@huawei.com,
        edmund.j.dea@intel.com, gregkh@linuxfoundation.org,
        joe@perches.com, john.stultz@linaro.org, lukas.bulwahn@gmail.com,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, punit1.agrawal@toshiba.co.jp,
        ralf.ramsauer@oth-regensburg.de, robh+dt@kernel.org,
        sam@ravnborg.org, wilken.gottwalt@posteo.net
Subject:  +
 maintainers-rectify-entry-for-intel-keem-bay-drm-driver.patch added to -mm
 tree
Message-ID: <20211027080556.wO1nol12n%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: rectify entry for INTEL KEEM BAY DRM DRIVER
has been added to the -mm tree.  Its filename is
     maintainers-rectify-entry-for-intel-keem-bay-drm-driver.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-rectify-entry-for-intel-keem-bay-drm-driver.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-rectify-entry-for-intel-keem-bay-drm-driver.patch

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
Subject: MAINTAINERS: rectify entry for INTEL KEEM BAY DRM DRIVER

Commit ed794057b052 ("drm/kmb: Build files for KeemBay Display driver")
refers to the non-existing file intel,kmb_display.yaml in
./Documentation/devicetree/bindings/display/.

Commit 5a76b1ed73b9 ("dt-bindings: display: Add support for Intel KeemBay
Display") originating from the same patch series however adds the file
intel,keembay-display.yaml in that directory instead.

So, refer to intel,keembay-display.yaml in the INTEL KEEM BAY DRM DRIVER
section instead.

Link: https://lkml.kernel.org/r/20211026141902.4865-4-lukas.bulwahn@gmail.com
Fixes: ed794057b052 ("drm/kmb: Build files for KeemBay Display driver")
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

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-rectify-entry-for-intel-keem-bay-drm-driver
+++ a/MAINTAINERS
@@ -9518,7 +9518,7 @@ INTEL KEEM BAY DRM DRIVER
 M:	Anitha Chrisanthus <anitha.chrisanthus@intel.com>
 M:	Edmund Dea <edmund.j.dea@intel.com>
 S:	Maintained
-F:	Documentation/devicetree/bindings/display/intel,kmb_display.yaml
+F:	Documentation/devicetree/bindings/display/intel,keembay-display.yaml
 F:	drivers/gpu/drm/kmb/
 
 INTEL KEEM BAY OCS AES/SM4 CRYPTO DRIVER
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

memory-remove-unused-config_mem_block_size.patch
maintainers-rectify-entry-for-arm-toshiba-visconti-architecture.patch
maintainers-rectify-entry-for-hikey960-onboard-usb-gpio-hub-driver.patch
maintainers-rectify-entry-for-intel-keem-bay-drm-driver.patch
maintainers-rectify-entry-for-allwinner-hardware-spinlock-support.patch

