Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FACC5479D
	for <mm-commits@archiver.kernel.org>; Thu, 12 Jan 2023 00:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjALAPg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 Jan 2023 19:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235523AbjALAPb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2023 19:15:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183BA1CB0B
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 16:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A661C61ED9
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2023 00:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D18C433F0;
        Thu, 12 Jan 2023 00:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673482527;
        bh=7garRkJtwn6+VJD3v2oLntZ7QCDYwb8YSGtYIZW/ZN8=;
        h=Date:To:From:Subject:From;
        b=oDni7+MHkO2pdATJUE+GIbHxU4Zsi7vZm2tb+ByI7vce6RHw/nQE31IGRZpAN5rYo
         qyj7p84QvdUoh7Ze7RABrRNs9ihTA+pODbfeqQZ1ubj53EfDN66axoY6VRCx/HAl0n
         14ic4299YIsjvS9bRLXmZdbkWVwLLgSm9PWveN2M=
Date:   Wed, 11 Jan 2023 16:15:25 -0800
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tkhai@ya.ru,
        rfoss@kernel.org, qyousef@layalina.io, kvalo@kernel.org,
        colin.i.king@gmail.com, baolin.wang@linux.alibaba.com,
        arnd@arndb.de, robert.foss@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-robert-foss-email-address.patch removed from -mm tree
Message-Id: <20230112001527.02D18C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: update Robert Foss' email address
has been removed from the -mm tree.  Its filename was
     maintainers-update-robert-foss-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -17237,7 +17237,7 @@ F:	Documentation/devicetree/bindings/net
 F:	drivers/net/wwan/qcom_bam_dmux.c
 
 QUALCOMM CAMERA SUBSYSTEM DRIVER
-M:	Robert Foss <robert.foss@linaro.org>
+M:	Robert Foss <rfoss@kernel.org>
 M:	Todor Tomov <todor.too@gmail.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
@@ -17317,7 +17317,7 @@ F:	drivers/dma/qcom/hidma*
 
 QUALCOMM I2C CCI DRIVER
 M:	Loic Poulain <loic.poulain@linaro.org>
-M:	Robert Foss <robert.foss@linaro.org>
+M:	Robert Foss <rfoss@kernel.org>
 L:	linux-i2c@vger.kernel.org
 L:	linux-arm-msm@vger.kernel.org
 S:	Maintained
_

Patches currently in -mm which might be from robert.foss@linaro.org are


