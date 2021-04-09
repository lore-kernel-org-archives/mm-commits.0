Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3632AC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F420561108
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhDIU1P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDIU1P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:27:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A80EC610A8;
        Fri,  9 Apr 2021 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618000022;
        bh=AK8tCDLjTJSPvDJvYpZ71F6nTpQ3k4ANVvzfBycLvE8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=O9SbnDh3nByWTD1LUMT6wFeSvWKwgbJAZmBGZyVG/rNLrkE5YKU69gMHrRDXnAS/+
         oYwTnxVLvhpuLSB8el7rNRnZWJhqrAnaXSLOWaadmPCNVILYtjm1kQLjGjr0JyNj/z
         BDfpt9VKJddnzd5fS07FwWy3RiD06+5TRoOhjr+g=
Date:   Fri, 09 Apr 2021 13:27:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bgolaszewski@baylibre.com,
        gregkh@linuxfoundation.org, jassisinghbrar@gmail.com,
        kabel@kernel.org, linus.walleij@linaro.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, pavel@ucw.cz,
        torvalds@linux-foundation.org
Subject:  [patch 01/16] MAINTAINERS: update CZ.NIC's Turris
 information
Message-ID: <20210409202701.XGAIC0VNd%akpm@linux-foundation.org>
In-Reply-To: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Marek Beh=C3=BAn <kabel@kernel.org>
Subject: MAINTAINERS: update CZ.NIC's Turris information

Add all the files maintained by Turris team, not only for MOX, but also
for Omnia.  Change website.

Link: https://lkml.kernel.org/r/20210325171123.28093-1-kabel@kernel.org
Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-update-cznics-turris-information
+++ a/MAINTAINERS
@@ -1790,19 +1790,26 @@ F:	drivers/net/ethernet/cortina/
 F:	drivers/pinctrl/pinctrl-gemini.c
 F:	drivers/rtc/rtc-ftrtc010.c
=20
-ARM/CZ.NIC TURRIS MOX SUPPORT
+ARM/CZ.NIC TURRIS SUPPORT
 M:	Marek Behun <marek.behun@nic.cz>
 S:	Maintained
-W:	http://mox.turris.cz
+W:	https://www.turris.cz/
 F:	Documentation/ABI/testing/debugfs-moxtet
 F:	Documentation/ABI/testing/sysfs-bus-moxtet-devices
 F:	Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm
 F:	Documentation/devicetree/bindings/bus/moxtet.txt
 F:	Documentation/devicetree/bindings/firmware/cznic,turris-mox-rwtm.txt
 F:	Documentation/devicetree/bindings/gpio/gpio-moxtet.txt
+F:	Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
+F:	Documentation/devicetree/bindings/watchdog/armada-37xx-wdt.txt
 F:	drivers/bus/moxtet.c
 F:	drivers/firmware/turris-mox-rwtm.c
+F:	drivers/leds/leds-turris-omnia.c
+F:	drivers/mailbox/armada-37xx-rwtm-mailbox.c
 F:	drivers/gpio/gpio-moxtet.c
+F:	drivers/watchdog/armada_37xx_wdt.c
+F:	include/dt-bindings/bus/moxtet.h
+F:	include/linux/armada-37xx-rwtm-mailbox.h
 F:	include/linux/moxtet.h
=20
 ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)
_
