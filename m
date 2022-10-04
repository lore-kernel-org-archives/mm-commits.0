Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8449C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  4 Oct 2022 18:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiJDSgc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiJDSgb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2022 14:36:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63A25A3FC
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 11:36:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A41A4B81B7D
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 18:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6A7C433C1;
        Tue,  4 Oct 2022 18:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664908586;
        bh=z6W77SbYRfuMj38QdiUpA4HSnhAPs/breX3pqMsN++M=;
        h=Date:To:From:Subject:From;
        b=da3A2qOur7e5Lmt1g2QCs8bZFw1RcBcp9cTjLJHjUA88t9uOAoWw06vnU2oP+jSfj
         PdyfKqNVTX1fVSmofYmZ4IsdreGu5R1P0/6Drdb+V9v8pj0HVlCNkjqlnb/2nCGsKC
         jV0rXsLnU6l9TCJytuDZXAF92bkyg+6mRnJospOI=
Date:   Tue, 04 Oct 2022 11:36:25 -0700
To:     mm-commits@vger.kernel.org, Tim.Bird@sony.com,
        frank.rowand@sony.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-frank-rowand-email-address.patch added to mm-nonmm-unstable branch
Message-Id: <20221004183626.3E6A7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Frank Rowand email address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-update-frank-rowand-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-frank-rowand-email-address.patch

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
From: Frank Rowand <frank.rowand@sony.com>
Subject: mailmap: update Frank Rowand email address
Date: Fri, 30 Sep 2022 20:50:09 -0500

Frank is no longer at Sony, add an entry for his latest Sony email

Link: https://lkml.kernel.org/r/20221001015009.3994518-1-frowand.list@gmail.com
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Cc: Tim Bird <Tim.Bird@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-frank-rowand-email-address
+++ a/.mailmap
@@ -134,6 +134,7 @@ Filipe Lautert <filipe@icewall.org>
 Finn Thain <fthain@linux-m68k.org> <fthain@telegraphics.com.au>
 Franck Bui-Huu <vagabon.xyz@gmail.com>
 Frank Rowand <frowand.list@gmail.com> <frank.rowand@am.sony.com>
+Frank Rowand <frowand.list@gmail.com> <frank.rowand@sony.com>
 Frank Rowand <frowand.list@gmail.com> <frank.rowand@sonymobile.com>
 Frank Rowand <frowand.list@gmail.com> <frowand@mvista.com>
 Frank Zago <fzago@systemfabricworks.com>
_

Patches currently in -mm which might be from frank.rowand@sony.com are

mailmap-update-frank-rowand-email-address.patch

