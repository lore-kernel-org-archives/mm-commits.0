Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263CAC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 22:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237626AbiGYWmP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237624AbiGYWlx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 18:41:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D08A27B1E
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 15:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58741B81131
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 22:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB09C341CD;
        Mon, 25 Jul 2022 22:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658788749;
        bh=aMQW548CPYotxmqsKrfwG3Lxd/yOePTXgGmzijsf4Tw=;
        h=Date:To:From:Subject:From;
        b=WB8ep7IP8MH5m0N0Oi1bp1G1ttZVo+D9S+YUszeXPnxurrzprBHyonN0RyBlnkXm2
         jK5D9trkfsAS3WS05b2YmtI0O0gGV6gTvqh0iKkdJ/H2iUvKRxtnGqu3r8HXaZOT8+
         pVBfnvN83YdPjigK04rBsJCex18IFgrSlNggXnGs=
Date:   Mon, 25 Jul 2022 15:39:07 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, dlatypov@google.com,
        davidgow@google.com, brendan.higgins@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-linuxdev-alias-for-brendan-higgins.patch added to mm-nonmm-unstable branch
Message-Id: <20220725223908.DAB09C341CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add linux.dev alias for Brendan Higgins
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-linuxdev-alias-for-brendan-higgins.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-linuxdev-alias-for-brendan-higgins.patch

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
From: Brendan Higgins <brendan.higgins@linux.dev>
Subject: mailmap: add linux.dev alias for Brendan Higgins
Date: Mon, 25 Jul 2022 17:58:33 -0400

Because of my new work remote setup at Google, I can no longer use command
line tools with my google.com email address, for this reason I got a
linux.dev account.  So update the mailmap to show the new alias I will be
using.

Link: https://lkml.kernel.org/r/20220725215833.789133-1-brendan.higgins@linux.dev
Signed-off-by: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Daniel Latypov <dlatypov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-linuxdev-alias-for-brendan-higgins
+++ a/.mailmap
@@ -71,6 +71,7 @@ Boris Brezillon <bbrezillon@kernel.org>
 Boris Brezillon <bbrezillon@kernel.org> <b.brezillon@overkiz.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
+Brendan Higgins <brendan.higgins@linux.dev> <brendanhiggins@google.com>
 Brian Avery <b.avery@hp.com>
 Brian King <brking@us.ibm.com>
 Brian Silverman <bsilver16384@gmail.com> <brian.silverman@bluerivertech.com>
_

Patches currently in -mm which might be from brendan.higgins@linux.dev are

mailmap-add-linuxdev-alias-for-brendan-higgins.patch

