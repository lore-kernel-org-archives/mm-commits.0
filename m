Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8168FC64EC4
	for <mm-commits@archiver.kernel.org>; Wed,  8 Mar 2023 20:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCHUSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Mar 2023 15:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjCHUSV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Mar 2023 15:18:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BDD3E089
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 12:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6552D61733
        for <mm-commits@vger.kernel.org>; Wed,  8 Mar 2023 20:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C007DC433EF;
        Wed,  8 Mar 2023 20:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678306691;
        bh=LDzO3rUB6j8aS+MeOvPBWAkPZJm2scZAE/XW7C7A2tI=;
        h=Date:To:From:Subject:From;
        b=tPXr0j0raEtUrY+EW6Y+xCn8sCVzrvQMiH9jjYIBy5x9vL4TCMp5R+RrLf36IdDW7
         xg5UjkTxK2kCPkS8JIjVQkWNWekR+U5etR7ajTbqbkZzd6ZcnyKUSsKeOxLHB2jXdD
         XwTN+gOs3NpNFa1pCdW+CXNq5c3H+LnwzG/H5Qks=
Date:   Wed, 08 Mar 2023 12:18:11 -0800
To:     mm-commits@vger.kernel.org, olivia@selenic.com,
        dwmw2@infradead.org, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-remove-the-obsolete-section-embedded-linux.patch added to mm-nonmm-unstable branch
Message-Id: <20230308201811.C007DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove the obsolete section EMBEDDED LINUX
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-remove-the-obsolete-section-embedded-linux.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-remove-the-obsolete-section-embedded-linux.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: remove the obsolete section EMBEDDED LINUX
Date: Wed, 8 Mar 2023 16:06:25 +0100

By now, many developers are working on Linux for embedded systems.  There
is no need to point out single developers.  The linux-embedded mailing
list has only little traffic, and most of it is just spam.

Remove this obsolete section.

Link: https://lkml.kernel.org/r/20230308150625.28732-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Olivia Mackall <olivia@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

maintainers-remove-the-obsolete-section-embedded-linux.patch

