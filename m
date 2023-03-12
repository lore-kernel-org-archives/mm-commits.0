Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80E7C6FA99
	for <mm-commits@archiver.kernel.org>; Sun, 12 Mar 2023 20:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbjCLU4S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 12 Mar 2023 16:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjCLU4R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 12 Mar 2023 16:56:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905A2279BA
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 13:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53B0CB80D15
        for <mm-commits@vger.kernel.org>; Sun, 12 Mar 2023 20:56:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D858C433EF;
        Sun, 12 Mar 2023 20:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678654574;
        bh=9x4R74Lfed5b75W3keoz8FzxkTxKQ17vyNC4SjkfVWQ=;
        h=Date:To:From:Subject:From;
        b=uz+0asUxBc21j5x78Xwf2OQHaq6RZ5pVylqmGVZSRZeyfMSZsV7SM51Bu+fDn4gcR
         QnXz+LeCgByCiLUZ/4xrol7Lp2P9IHYh+B3Xjvm7NycyGSIjkx2+b5ui5rU3uD1r8Y
         Wm59gScBX7WdJW/idumtwhEaZqXa++mpkbw6g+hA=
Date:   Sun, 12 Mar 2023 13:56:13 -0700
To:     mm-commits@vger.kernel.org, tklauser@distanz.ch,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-tobias-klauser.patch added to mm-hotfixes-unstable branch
Message-Id: <20230312205614.0D858C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for Tobias Klauser
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-tobias-klauser.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-tobias-klauser.patch

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
From: Tobias Klauser <tklauser@distanz.ch>
Subject: mailmap: add entry for Tobias Klauser
Date: Fri, 10 Mar 2023 13:35:08 +0100

Map my old email addresses to the current address.

Link: https://lkml.kernel.org/r/20230310123508.22079-1-tklauser@distanz.ch
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-add-entry-for-tobias-klauser
+++ a/.mailmap
@@ -426,6 +426,10 @@ Thomas Graf <tgraf@suug.ch>
 Thomas Körper <socketcan@esd.eu> <thomas.koerper@esd.eu>
 Thomas Pedersen <twp@codeaurora.org>
 Tiezhu Yang <yangtiezhu@loongson.cn> <kernelpatch@126.com>
+Tobias Klauser <tklauser@distanz.ch> <tobias.klauser@gmail.com>
+Tobias Klauser <tklauser@distanz.ch> <klto@zhaw.ch>
+Tobias Klauser <tklauser@distanz.ch> <tklauser@nuerscht.ch>
+Tobias Klauser <tklauser@distanz.ch> <tklauser@xenon.tklauser.home>
 Todor Tomov <todor.too@gmail.com> <todor.tomov@linaro.org>
 Tony Luck <tony.luck@intel.com>
 TripleX Chung <xxx.phy@gmail.com> <triplex@zh-kernel.org>
_

Patches currently in -mm which might be from tklauser@distanz.ch are

mailmap-add-entry-for-tobias-klauser.patch

