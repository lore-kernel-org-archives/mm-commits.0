Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B36FC5479D
	for <mm-commits@archiver.kernel.org>; Sat,  7 Jan 2023 00:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjAGAy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Jan 2023 19:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjAGAy2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jan 2023 19:54:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A9713E80
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 16:54:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F035B81F44
        for <mm-commits@vger.kernel.org>; Sat,  7 Jan 2023 00:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20608C433F0;
        Sat,  7 Jan 2023 00:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673052864;
        bh=NPTbXmUaiVkxo5172GjlAhIxUBgdMIxiU6LXk83fO38=;
        h=Date:To:From:Subject:From;
        b=YAa/KkuzL8c7fpDgzxKwq2Eu/Wwk6bJuRmXBqdIeYyBDeOpOzN2ZWf3iVH2SaHAEk
         ZfvMZ5PdmXYzwrBnOn3jJXFcXxXZlg4RwNLcJNbIh4xtauw3deaNHdcmjp9ebmc8C7
         Cz/EFDEvrn69zfCjvVvODz6Oqlsr3kamaDhuah2w=
Date:   Fri, 06 Jan 2023 16:54:23 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        rfoss@kernel.org, qyousef@layalina.io, kvalo@kernel.org,
        colin.i.king@gmail.com, baolin.wang@linux.alibaba.com,
        arnd@arndb.de, robert.foss@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-robert-foss-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20230107005424.20608C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Robert Foss' email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-robert-foss-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-robert-foss-email-address.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Robert Foss <robert.foss@linaro.org>
Subject: MAINTAINERS: update Robert Foss' email address
Date: Fri, 6 Jan 2023 16:21:51 +0100

Update the email address for Robert's maintainer entries and fill in
.mailmap accordingly.

Link: https://lkml.kernel.org/r/20230106152151.115648-1-robert.foss@linaro.org
Signed-off-by: Robert Foss <rfoss@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/.mailmap~maintainers-update-robert-foss-email-address
+++ a/.mailmap
@@ -371,6 +371,7 @@ Rémi Denis-Courmont <rdenis@simphalempi
 Ricardo Ribalda <ribalda@kernel.org> <ricardo@ribalda.com>
 Ricardo Ribalda <ribalda@kernel.org> Ricardo Ribalda Delgado <ribalda@kernel.org>
 Ricardo Ribalda <ribalda@kernel.org> <ricardo.ribalda@gmail.com>
+Robert Foss <rfoss@kernel.org> <robert.foss@linaro.org>
 Roman Gushchin <roman.gushchin@linux.dev> <guro@fb.com>
 Roman Gushchin <roman.gushchin@linux.dev> <guroan@gmail.com>
 Roman Gushchin <roman.gushchin@linux.dev> <klamm@yandex-team.ru>
--- a/MAINTAINERS~maintainers-update-robert-foss-email-address
+++ a/MAINTAINERS
@@ -6948,7 +6948,7 @@ F:	drivers/gpu/drm/atmel-hlcdc/
 DRM DRIVERS FOR BRIDGE CHIPS
 M:	Andrzej Hajda <andrzej.hajda@intel.com>
 M:	Neil Armstrong <neil.armstrong@linaro.org>
-M:	Robert Foss <robert.foss@linaro.org>
+M:	Robert Foss <rfoss@kernel.org>
 R:	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
 R:	Jonas Karlman <jonas@kwiboo.se>
 R:	Jernej Skrabec <jernej.skrabec@gmail.com>
@@ -17229,7 +17229,7 @@ F:	Documentation/devicetree/bindings/net
 F:	drivers/net/wwan/qcom_bam_dmux.c
 
 QUALCOMM CAMERA SUBSYSTEM DRIVER
-M:	Robert Foss <robert.foss@linaro.org>
+M:	Robert Foss <rfoss@kernel.org>
 M:	Todor Tomov <todor.too@gmail.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
@@ -17309,7 +17309,7 @@ F:	drivers/dma/qcom/hidma*
 
 QUALCOMM I2C CCI DRIVER
 M:	Loic Poulain <loic.poulain@linaro.org>
-M:	Robert Foss <robert.foss@linaro.org>
+M:	Robert Foss <rfoss@kernel.org>
 L:	linux-i2c@vger.kernel.org
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from robert.foss@linaro.org are

maintainers-update-robert-foss-email-address.patch

