Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA488C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379401AbiFQCMc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379694AbiFQCM3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B8364BEC
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43179B82693
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6815C34114;
        Fri, 17 Jun 2022 02:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431941;
        bh=3ZnAbG6QnNumFGXcliS+1Ae0wPD3T0avll//1phrzXM=;
        h=Date:To:From:Subject:From;
        b=Ttyzu2fyg2VLjL3n8LibAhcDES6TlCrYtx+A29jxGCJQ5Au1ndMe4eg88/sMwIwWV
         uM3d+aHjGXhSb5/u9FtxMCYNcuMzV2JjeijCC7D094/7rRlQmYit3mrcUxKgOFLDfR
         t+6A5jMGDGu9Qoc6gapJD1JBpT3CCYtjeXtL7JPQ=
Date:   Thu, 16 Jun 2022 19:12:20 -0700
To:     mm-commits@vger.kernel.org, sboyd@kernel.org, arnd@arndb.de,
        aisheng.dong@nxp.com, abelvesa@nxp.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-abel-vesas-email.patch removed from -mm tree
Message-Id: <20220617021220.E6815C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: update Abel Vesa's email
has been removed from the -mm tree.  Its filename was
     maintainers-update-abel-vesas-email.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Abel Vesa <abelvesa@nxp.com>
Subject: MAINTAINERS: update Abel Vesa's email
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
@@ -14274,7 +14274,7 @@ F:	drivers/iio/gyro/fxas21002c_i2c.c
 F:	drivers/iio/gyro/fxas21002c_spi.c
 
 NXP i.MX CLOCK DRIVERS
-M:	Abel Vesa <abel.vesa@nxp.com>
+M:	Abel Vesa <abelvesa@kernel.org>
 L:	linux-clk@vger.kernel.org
 L:	linux-imx@nxp.com
 S:	Maintained
_

Patches currently in -mm which might be from abelvesa@nxp.com are


