Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49357C433E1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26BBD619A0
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhC1TMQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231598AbhC1TLr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A482B61981;
        Sun, 28 Mar 2021 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958707;
        bh=1g5uHYpZ5wBeXGlmzOMoStsX6bS5iKDdaSDEeqxtnlM=;
        h=Date:From:To:Subject:From;
        b=Pe9rOu/vGq4kKnSR1N6qkhQBLo9sXRKsO5S/D/BYW5icIch4RgnN4QzMzqnaa9feX
         wDJD7g5qrWEFUZ8RecoVC6IYI0C3eOCVP7wNfAp6EEbyKCTFWwhw84tVkehRraCvUE
         NbOq8dPnjFxBdwm9LSFGdVw0fN4DNNP7Q8BO3YRA=
Date:   Sun, 28 Mar 2021 12:11:46 -0700
From:   akpm@linux-foundation.org
To:     bgolaszewski@baylibre.com, gregkh@linuxfoundation.org,
        jassisinghbrar@gmail.com, kabel@kernel.org,
        linus.walleij@linaro.org, mm-commits@vger.kernel.org, pavel@ucw.cz
Subject:  + maintainers-update-cznics-turris-information.patch
 added to -mm tree
Message-ID: <20210328191146.6yoKGwN3W%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update CZ.NIC's Turris information
has been added to the -mm tree.  Its filename is
     maintainers-update-cznics-turris-information.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-cznics-tur=
ris-information.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-cznics-tur=
ris-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from kabel@kernel.org are

maintainers-update-cznics-turris-information.patch
treewide-change-my-e-mail-address-fix-my-name.patch

