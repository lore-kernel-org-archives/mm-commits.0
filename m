Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB728C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 17 Oct 2022 00:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJQAgJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 16 Oct 2022 20:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJQAgJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 16 Oct 2022 20:36:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488CB34707
        for <mm-commits@vger.kernel.org>; Sun, 16 Oct 2022 17:36:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3E9FB80D5B
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 00:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93733C433C1;
        Mon, 17 Oct 2022 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665966965;
        bh=Ao6br6pKAjKzfMt/hfZZPGqDo1JU/CUVsr81DKDQRq4=;
        h=Date:To:From:Subject:From;
        b=diVp1JoVYr5nLO4AXFzE18dwA7MD04yjERK649MYODwOv1aVMdooH3txmVp4/LrWx
         kiAnVsEeTim/5af+uoP/8bKGSXT2chICxySW2ZPPneGVmXeWWmqX9+qb2kY7HWuJoP
         51jv3Wu9QCO0nr8w3MEbFcsqz+vCyDkQoKieL2dg=
Date:   Sun, 16 Oct 2022 17:36:04 -0700
To:     mm-commits@vger.kernel.org, qyousef@layalina.io,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-email-for-qais-yousef.patch added to mm-hotfixes-unstable branch
Message-Id: <20221017003605.93733C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update email for Qais Yousef
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-email-for-qais-yousef.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-email-for-qais-yousef.patch

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
From: Qais Yousef <qyousef@layalina.io>
Subject: mailmap: update email for Qais Yousef
Date: Fri, 14 Oct 2022 15:10:16 +0100

Update my email address for old entry and add a new entry for my
contribution while working with arm to continue support that work.

Link: https://lkml.kernel.org/r/20221014141016.539625-1-qyousef@layalina.io
Signed-off-by: Qais Yousef <qyousef@layalina.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~mailmap-update-email-for-qais-yousef
+++ a/.mailmap
@@ -354,7 +354,8 @@ Peter Oruba <peter@oruba.de>
 Pratyush Anand <pratyush.anand@gmail.com> <pratyush.anand@st.com>
 Praveen BP <praveenbp@ti.com>
 Punit Agrawal <punitagrawal@gmail.com> <punit.agrawal@arm.com>
-Qais Yousef <qsyousef@gmail.com> <qais.yousef@imgtec.com>
+Qais Yousef <qyousef@layalina.io> <qais.yousef@imgtec.com>
+Qais Yousef <qyousef@layalina.io> <qais.yousef@arm.com>
 Quentin Monnet <quentin@isovalent.com> <quentin.monnet@netronome.com>
 Quentin Perret <qperret@qperret.net> <quentin.perret@arm.com>
 Rafael J. Wysocki <rjw@rjwysocki.net> <rjw@sisk.pl>
_

Patches currently in -mm which might be from qyousef@layalina.io are

mailmap-update-email-for-qais-yousef.patch

