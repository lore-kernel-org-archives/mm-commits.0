Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759E3C38142
	for <mm-commits@archiver.kernel.org>; Tue, 31 Jan 2023 22:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjAaWdr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 17:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjAaWdq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 17:33:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BF6113E6
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 14:33:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1031761737
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 22:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65972C433D2;
        Tue, 31 Jan 2023 22:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675204423;
        bh=cAJGOKgE269U2HG08HBzVw7EzSp178jxESXkNeEJCJI=;
        h=Date:To:From:Subject:From;
        b=0Ni/hPN44HLPXGODsCI8fZB0pBWL1PLOPnDc+OToew0neR33vlrjgEQ2ZcyS/P0lq
         FBQQFnmgsMunHgJXl9zqWASdgrcKJULg0JIU2Qv83yE5CLEv0ayC9ydXxvAenKD5H2
         aItnsyK0efiEK+2U4bVB4v+BWwCDP1vLD8oOinkM=
Date:   Tue, 31 Jan 2023 14:33:42 -0800
To:     mm-commits@vger.kernel.org, aleksandr.mikhalitsyn@canonical.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-alexander-mikhalitsyn.patch added to mm-hotfixes-unstable branch
Message-Id: <20230131223343.65972C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for Alexander Mikhalitsyn
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-alexander-mikhalitsyn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-alexander-mikhalitsyn.patch

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
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Subject: mailmap: add entry for Alexander Mikhalitsyn
Date: Tue, 31 Jan 2023 13:34:56 +0100

My old email <alexander.mikhalitsyn@virtuozzo.com> isn't working
anymore.

Link: https://lkml.kernel.org/r/20230131123456.192657-1-aleksandr.mikhalitsyn@canonical.com
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-alexander-mikhalitsyn
+++ a/.mailmap
@@ -25,6 +25,8 @@ Aleksey Gorelov <aleksey_gorelov@phoenix
 Alexander Lobakin <alobakin@pm.me> <alobakin@dlink.ru>
 Alexander Lobakin <alobakin@pm.me> <alobakin@marvell.com>
 Alexander Lobakin <alobakin@pm.me> <bloodyreaper@yandex.ru>
+Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
+Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
 Alexandre Belloni <alexandre.belloni@bootlin.com> <alexandre.belloni@free-electrons.com>
 Alexei Starovoitov <ast@kernel.org> <alexei.starovoitov@gmail.com>
 Alexei Starovoitov <ast@kernel.org> <ast@fb.com>
_

Patches currently in -mm which might be from aleksandr.mikhalitsyn@canonical.com are

mailmap-add-entry-for-alexander-mikhalitsyn.patch

