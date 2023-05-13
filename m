Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C38EC77B7F
	for <mm-commits@archiver.kernel.org>; Sat, 13 May 2023 00:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbjEMAI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 20:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjEMAIZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 20:08:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE771BE6
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 17:08:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CAEB60E06
        for <mm-commits@vger.kernel.org>; Sat, 13 May 2023 00:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7461DC433EF;
        Sat, 13 May 2023 00:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683936503;
        bh=qanyD28LOHUHZQS3Pqe6hzkDM4iIWzPV+u7k+P/tA14=;
        h=Date:To:From:Subject:From;
        b=i6YTmA27BqZiGmY2JuFVir7+GvMBcJ8dl34pzqyYWQvr5sgJtQNsDoNcPpkUJxnmd
         WID98UeOINTOOmhnqIWCXmrsEZBxBZrCLeT2BQ6AhhVi3fgBNPsaWPZy2taK1exeto
         Kxy5xTAGpR2rxDoT03L7gZY3xumBnwcdEP8VkEhs=
Date:   Fri, 12 May 2023 17:08:22 -0700
To:     mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        mihail.atanassov@arm.com, joe@perches.com,
        gregkh@linuxfoundation.org, brian.starkey@arm.com,
        liviu.dudau@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-cleanup-arm-display-ip-maintainers.patch added to mm-hotfixes-unstable branch
Message-Id: <20230513000823.7461DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Cleanup Arm Display IP maintainers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-cleanup-arm-display-ip-maintainers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-cleanup-arm-display-ip-maintainers.patch

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
From: Liviu Dudau <liviu.dudau@arm.com>
Subject: MAINTAINERS: Cleanup Arm Display IP maintainers
Date: Wed, 10 May 2023 13:28:11 +0100

Some people have moved to different roles and are no longer involved in
the upstream development.  As there is only one person left, remove the
mailing list as well as it serves no purpose.

Link: https://lkml.kernel.org/r/20230510122811.1872358-1-liviu.dudau@arm.com
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Acked-by: Brian Starkey <brian.starkey@arm.com>
Cc: Mihail Atanassov <mihail.atanassov@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com> # "Please use --order"
Cc: Mihail Atanassov <mihail.atanassov@arm.com>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 -----
 1 file changed, 5 deletions(-)

--- a/MAINTAINERS~maintainers-cleanup-arm-display-ip-maintainers
+++ a/MAINTAINERS
@@ -1666,10 +1666,7 @@ F:	drivers/power/reset/arm-versatile-reb
 F:	drivers/soc/versatile/
 
 ARM KOMEDA DRM-KMS DRIVER
-M:	James (Qian) Wang <james.qian.wang@arm.com>
 M:	Liviu Dudau <liviu.dudau@arm.com>
-M:	Mihail Atanassov <mihail.atanassov@arm.com>
-L:	Mali DP Maintainers <malidp@foss.arm.com>
 S:	Supported
 T:	git git://anongit.freedesktop.org/drm/drm-misc
 F:	Documentation/devicetree/bindings/display/arm,komeda.yaml
@@ -1690,8 +1687,6 @@ F:	include/uapi/drm/panfrost_drm.h
 
 ARM MALI-DP DRM DRIVER
 M:	Liviu Dudau <liviu.dudau@arm.com>
-M:	Brian Starkey <brian.starkey@arm.com>
-L:	Mali DP Maintainers <malidp@foss.arm.com>
 S:	Supported
 T:	git git://anongit.freedesktop.org/drm/drm-misc
 F:	Documentation/devicetree/bindings/display/arm,malidp.yaml
_

Patches currently in -mm which might be from liviu.dudau@arm.com are

maintainers-cleanup-arm-display-ip-maintainers.patch

