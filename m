Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE3DC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJUEeo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJUEen (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57D4120A4
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4768061263
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A02DC433C1;
        Fri, 21 Oct 2022 04:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326880;
        bh=gHUVDygl4uATNobBUVAv0UkfURk9mFqBEAO3fy1PBqc=;
        h=Date:To:From:Subject:From;
        b=ztHw5YOhQW8r3nPH7FXoxxSUAjg36IHtMD85rnlRw1cR6sx6Flv/bctRxQHzZbpLw
         Y5szF73cNr4L0iWKxFbU3mdxtIw0dKrALK8AL4K0JDA0VoRqB4L13klIf66lo+L2T8
         K2YtT2Clc3pv50MfdDiDDAsDfmC2M5vACM62gLj0=
Date:   Thu, 20 Oct 2022 21:34:39 -0700
To:     mm-commits@vger.kernel.org, qsyousef@gmail.com,
        qais.yousef@arm.com, qyousef@layalina.io, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-email-for-qais-yousef.patch removed from -mm tree
Message-Id: <20221021043440.9A02DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update email for Qais Yousef
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-for-qais-yousef.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qais Yousef <qyousef@layalina.io>
Subject: mailmap: update email for Qais Yousef
Date: Fri, 14 Oct 2022 15:10:16 +0100

Update my email address for old entry and add a new entry for my
contribution while working with arm to continue support that work.

Link: https://lkml.kernel.org/r/20221014141016.539625-1-qyousef@layalina.io
Signed-off-by: Qais Yousef <qyousef@layalina.io>
Acked-by: Qais Yousef <qais.yousef@arm.com>
Acked-by: Qais Yousef <qsyousef@gmail.com>
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


