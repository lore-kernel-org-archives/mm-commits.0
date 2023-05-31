Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CA6C7EE29
	for <mm-commits@archiver.kernel.org>; Wed, 31 May 2023 21:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjEaVgA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 May 2023 17:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjEaVfs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2023 17:35:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2293E1BDA
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 14:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40FE06342F
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 21:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979CAC4339B;
        Wed, 31 May 2023 21:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685568794;
        bh=M9AApsukkOyR4ZsjXP7ZlsqwlzoB91Fv7UM3+yUa+Mc=;
        h=Date:To:From:Subject:From;
        b=IEhrUccPcxAw8Ij/rQFC3Qq/gZ57q/dy6mo7fQp1qO6BaUBcSGGRcwixG+DLSrcZF
         Cc0i+caPB233E4BtmhJBxnpG5NZRx7xP4gO9btyNphIy5QY8dfDjn3pd/DoQ7TMYHs
         DJ/R2xlDUVUCA4xgs6GcI2QfqnEjPbITUyvQzyOg=
Date:   Wed, 31 May 2023 14:33:13 -0700
To:     mm-commits@vger.kernel.org, john@keeping.me.uk,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-john-keeping.patch added to mm-hotfixes-unstable branch
Message-Id: <20230531213314.979CAC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for John Keeping
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-john-keeping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entry-for-john-keeping.patch

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
From: John Keeping <john@keeping.me.uk>
Subject: mailmap: add entry for John Keeping
Date: Wed, 31 May 2023 15:48:39 +0100

Map my corporate address to my personal one, as I am leaving the
company.

Link: https://lkml.kernel.org/r/20230531144839.1157112-1-john@keeping.me.uk
Signed-off-by: John Keeping <john@keeping.me.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-john-keeping
+++ a/.mailmap
@@ -233,6 +233,7 @@ Jisheng Zhang <jszhang@kernel.org> <Jish
 Johan Hovold <johan@kernel.org> <jhovold@gmail.com>
 Johan Hovold <johan@kernel.org> <johan@hovoldconsulting.com>
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
+John Keeping <john@keeping.me.uk> <john@metanate.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
 John Stultz <johnstul@us.ibm.com>
 <jon.toppins+linux@gmail.com> <jtoppins@cumulusnetworks.com>
_

Patches currently in -mm which might be from john@keeping.me.uk are

mailmap-add-entry-for-john-keeping.patch

