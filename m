Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BE4C77B72
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbjDFCxw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbjDFCxa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:53:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFA493C5
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0D116421A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126CBC433D2;
        Thu,  6 Apr 2023 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749589;
        bh=uTtwZrfYhi148fxBprWeq8wd1jdbDx9axoa7DPihgfY=;
        h=Date:To:From:Subject:From;
        b=xRIDKRE38GRabQU4CDbfu2b5L0af7Iq/ka1n6QYPGemipZ209nNS5Bsh3TDN1/C52
         PKhFU+qcyjmgw6m6+dD2Wr47pBQmEwzxqcY4xps3TZFrAOx6QiMblBOTJfhch8XbDh
         WmTPYK1CXc9e1+RiIvynbD401ZCjn/7AVbsYii8U=
Date:   Wed, 05 Apr 2023 19:53:08 -0700
To:     mm-commits@vger.kernel.org, olivia@selenic.com,
        dwmw2@infradead.org, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-remove-the-obsolete-section-embedded-linux.patch removed from -mm tree
Message-Id: <20230406025309.126CBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: remove the obsolete section EMBEDDED LINUX
has been removed from the -mm tree.  Its filename was
     maintainers-remove-the-obsolete-section-embedded-linux.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: remove the obsolete section EMBEDDED LINUX
Date: Wed, 8 Mar 2023 16:06:25 +0100

By now, many developers are working on Linux for embedded systems.  There
is no need to point out single developers.  The linux-embedded mailing
list has only little traffic, and most of it is just spam.

Remove this obsolete section.

Link: https://lkml.kernel.org/r/20230308150625.28732-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: David Woodhouse <dwmw2@infradead.org>
Cc: Olivia Mackall <olivia@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

--- a/MAINTAINERS~maintainers-remove-the-obsolete-section-embedded-linux
+++ a/MAINTAINERS
@@ -7525,12 +7525,6 @@ T:	git git://linuxtv.org/media_tree.git
 F:	Documentation/admin-guide/media/em28xx*
 F:	drivers/media/usb/em28xx/
 
-EMBEDDED LINUX
-M:	Olivia Mackall <olivia@selenic.com>
-M:	David Woodhouse <dwmw2@infradead.org>
-L:	linux-embedded@vger.kernel.org
-S:	Maintained
-
 EMMC CMDQ HOST CONTROLLER INTERFACE (CQHCI) DRIVER
 M:	Adrian Hunter <adrian.hunter@intel.com>
 M:	Ritesh Harjani <riteshh@codeaurora.org>
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are


