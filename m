Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E49B4C43334
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 20:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiFKU1l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 16:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbiFKU1j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 16:27:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BC26AA56
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 13:27:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B1D361283
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 20:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B179AC34116;
        Sat, 11 Jun 2022 20:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654979256;
        bh=W1/zGeXWrMFkRUvdDjBJGdgQ0kDvWnLBpxXEhDW32OY=;
        h=Date:To:From:Subject:From;
        b=g/JfEAEiSqWDTb7JWT2iioUUAzNwG0Tpupoa6lRoseMJBx/LWuyLu2kqsMvZD30OD
         8b7vLIW2HoZX90uDJWUfPOK+6alevRXaAEptNFNGgOMfikfiR6ogaW5NWcHxjdQHj8
         uaGtFi7tWwyY5fRRTtdnbfc3IlcWNcMACp0kW7zo=
Date:   Sat, 11 Jun 2022 13:27:35 -0700
To:     mm-commits@vger.kernel.org, sboyd@kernel.org, arnd@arndb.de,
        aisheng.dong@nxp.com, abelvesa@nxp.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-abel-vesas-email.patch added to mm-hotfixes-unstable branch
Message-Id: <20220611202736.B179AC34116@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Update Abel Vesa's email
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-update-abel-vesas-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-abel-vesas-email.patch

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
From: abelvesa@kernel.org
Subject: MAINTAINERS: Update Abel Vesa's email
Date: Sat, 11 Jun 2022 12:31:42 +0300


Use Abel Vesa's kernel.org account in maintainer entry and mailmap.

Link: https://lkml.kernel.org/r/20220611093142.202271-1-abelvesa@kernel.org
Signed-off-by: Abel Vesa <abelvesa@nxp.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Dong Aisheng <aisheng.dong@nxp.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    2 ++
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-abel-vesas-email
+++ a/.mailmap
@@ -10,6 +10,8 @@
 # Please keep this list dictionary sorted.
 #
 Aaron Durbin <adurbin@google.com>
+Abel Vesa <abelvesa@kernel.org> <abel.vesa@nxp.com>
+Abel Vesa <abelvesa@kernel.org> <abelvesa@gmail.com>
 Abhinav Kumar <quic_abhinavk@quicinc.com> <abhinavk@codeaurora.org>
 Adam Oldham <oldhamca@gmail.com>
 Adam Radford <aradford@gmail.com>
--- a/MAINTAINERS~maintainers-update-abel-vesas-email
+++ a/MAINTAINERS
@@ -14265,7 +14265,7 @@ F:	drivers/iio/gyro/fxas21002c_i2c.c
 F:	drivers/iio/gyro/fxas21002c_spi.c
 
 NXP i.MX CLOCK DRIVERS
-M:	Abel Vesa <abel.vesa@nxp.com>
+M:	Abel Vesa <abelvesa@kernel.org>
 L:	linux-clk@vger.kernel.org
 L:	linux-imx@nxp.com
 S:	Maintained
_

Patches currently in -mm which might be from abelvesa@nxp.com are

maintainers-update-abel-vesas-email.patch

