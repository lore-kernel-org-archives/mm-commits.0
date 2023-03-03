Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33AEC6FA8E
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 02:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCCCaM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Mar 2023 21:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCCCaM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Mar 2023 21:30:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69F122A17
        for <mm-commits@vger.kernel.org>; Thu,  2 Mar 2023 18:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D86CB812A3
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 02:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A5DC433D2;
        Fri,  3 Mar 2023 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677810608;
        bh=+fChhzPNGeyN+QNNog9tRjRxYzjtLOpS7R7UGMwrrcc=;
        h=Date:To:From:Subject:From;
        b=BPSjxENYY8IMjCmwxdW7CJnVm1LhUVndg+/askRfJYrRVKhVhJiJOAE6hN1HponIW
         3O1S+ccYn6Jhn7BD0rbcUaVyRydl8uPR83zAAkkLt9IVbvCoVFghnNfIS0L90DfERI
         DEuKqSkLPPBu0HKAXVZEnvXbdxxaBjb/VzMV4Bow=
Date:   Thu, 02 Mar 2023 18:30:07 -0800
To:     mm-commits@vger.kernel.org, conor.dooley@microchip.com,
        alex@ghiti.fr, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-alexandre-ghiti-personal-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20230303023008.22A5DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: .mailmap: add Alexandre Ghiti personal email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-alexandre-ghiti-personal-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-alexandre-ghiti-personal-email-address.patch

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
From: Alexandre Ghiti <alex@ghiti.fr>
Subject: .mailmap: add Alexandre Ghiti personal email address
Date: Wed, 1 Mar 2023 10:01:32 +0100

I'm no longer employed by Canonical which results in email bouncing so add
an entry to my personal email address.

Link: https://lkml.kernel.org/r/20230301090132.280475-1-alexghiti@rivosinc.com
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/.mailmap~mailmap-add-alexandre-ghiti-personal-email-address
+++ a/.mailmap
@@ -28,6 +28,7 @@ Alexander Lobakin <alobakin@pm.me> <bloo
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <alexander.mikhalitsyn@virtuozzo.com>
 Alexander Mikhalitsyn <alexander@mihalicyn.com> <aleksandr.mikhalitsyn@canonical.com>
 Alexandre Belloni <alexandre.belloni@bootlin.com> <alexandre.belloni@free-electrons.com>
+Alexandre Ghiti <alex@ghiti.fr> <alexandre.ghiti@canonical.com>
 Alexei Starovoitov <ast@kernel.org> <alexei.starovoitov@gmail.com>
 Alexei Starovoitov <ast@kernel.org> <ast@fb.com>
 Alexei Starovoitov <ast@kernel.org> <ast@plumgrid.com>
_

Patches currently in -mm which might be from alex@ghiti.fr are

mailmap-add-alexandre-ghiti-personal-email-address.patch

