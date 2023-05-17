Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0803C7EE2E
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 22:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjEQWZd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 18:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjEQWZZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 18:25:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF084EED
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 15:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46A1864030
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 22:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C07FC433EF;
        Wed, 17 May 2023 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684362323;
        bh=bnrJ8aldd4WBW+yxxCvER/TermEpF3mtMlxxMvaR3qQ=;
        h=Date:To:From:Subject:From;
        b=1D3X7z710lv1SxDctjw4y76sUIFVSJkPPYjfQEA6vu7upd8Nw508vmhvXmi1moL5x
         GjeoamSQQgpJKB9POcYoLFpeNbh6OJ6oH0Hb6RSiTEBOGO8zdY+2Ti6O6B39UP07cO
         rycoSodS7Ufydc3jZAMZZthaXMQSBVGm+jOU5j3c=
Date:   Wed, 17 May 2023 15:25:23 -0700
To:     mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de,
        mihail.atanassov@arm.com, joe@perches.com,
        gregkh@linuxfoundation.org, brian.starkey@arm.com,
        liviu.dudau@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-cleanup-arm-display-ip-maintainers.patch removed from -mm tree
Message-Id: <20230517222523.9C07FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: Cleanup Arm Display IP maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-cleanup-arm-display-ip-maintainers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


