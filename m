Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E13C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Jun 2022 19:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356374AbiFGTyI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 15:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358476AbiFGTwc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 15:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A4515C894
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 11:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35904B8237B
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 18:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97A3C385A5;
        Tue,  7 Jun 2022 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654626041;
        bh=ZUkFBFoIoOqOHsc6eufI3yNB7DXBbjORzjPMWJRcWiA=;
        h=Date:To:From:Subject:From;
        b=WEANRE3iRbfmQDEs1cvF4Nw/I+LXAo6nVTukRaRO0kUzPlre9iMFmVS9sbZj2QlqP
         oAU4eyPfQrvACin4Rkjt1Uuq6TvItTX4ItIPHyPv2cH4BbdmRNg9utdAJmifVs4jxL
         wuTolTTYOlTSx6SfGIrTjNaNng1MyMBr1phWcRG4=
Date:   Tue, 07 Jun 2022 11:20:40 -0700
To:     mm-commits@vger.kernel.org, jarkko@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-alias-for-jarkko-profiancom.patch added to mm-hotfixes-unstable branch
Message-Id: <20220607182040.E97A3C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add alias for jarkko@profian.com
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-alias-for-jarkko-profiancom.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-alias-for-jarkko-profiancom.patch

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
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: mailmap: add alias for jarkko@profian.com
Date: Tue, 7 Jun 2022 19:41:39 +0300

Add alias for patches that I contribute on behalf of Profian
(my current employer).

Link: https://lkml.kernel.org/r/20220607164140.1230876-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-alias-for-jarkko-profiancom
+++ a/.mailmap
@@ -165,6 +165,7 @@ Jan Glauber <jan.glauber@gmail.com> <jan
 Jan Glauber <jan.glauber@gmail.com> <jang@linux.vnet.ibm.com>
 Jan Glauber <jan.glauber@gmail.com> <jglauber@cavium.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
+Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are

mailmap-add-alias-for-jarkko-profiancom.patch

