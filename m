Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E00C76196
	for <mm-commits@archiver.kernel.org>; Tue, 11 Apr 2023 03:39:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjDKDjN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDKDjM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2023 23:39:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919EF1BC9
        for <mm-commits@vger.kernel.org>; Mon, 10 Apr 2023 20:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2882161C32
        for <mm-commits@vger.kernel.org>; Tue, 11 Apr 2023 03:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4F3C433EF;
        Tue, 11 Apr 2023 03:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681184350;
        bh=e9i4rzSGq40BznbWrBhqkMceB8KoB19yDr/Nd3T28G4=;
        h=Date:To:From:Subject:From;
        b=eJUegBg1+da6/P38T90hj2MvyHx51C8UIEh5b0kVILI6GYQNzDbVZmt/B3SMFtMOc
         H7mDjO/ESZHJnuRIEUvlH8PL88eGBjrpUdfS0syYHM4Xp20yoXXLAHPDJ9ZLRXS85f
         epGuf7WpR/1wx5HNDC5JoNFrYxkiWGUIiQ3yXfsY=
Date:   Mon, 10 Apr 2023 20:39:09 -0700
To:     mm-commits@vger.kernel.org, tkhai@ya.ru,
        stephen@networkplumber.org, qyousef@layalina.io, kuba@kernel.org,
        konrad.dybcio@linaro.org, colin.i.king@gmail.com,
        jtoppins@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-jtoppins-entry-to-reference-correct-email.patch added to mm-hotfixes-unstable branch
Message-Id: <20230411033910.7A4F3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update jtoppins' entry to reference correct email
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-jtoppins-entry-to-reference-correct-email.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-jtoppins-entry-to-reference-correct-email.patch

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
From: Jonathan Toppins <jtoppins@redhat.com>
Subject: mailmap: update jtoppins' entry to reference correct email
Date: Mon, 10 Apr 2023 17:39:35 -0400

Link: https://lkml.kernel.org/r/d79bc6eaf65e68bd1c2a1e1510ab6291ce5926a6.1681162487.git.jtoppins@redhat.com
Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Qais Yousef <qyousef@layalina.io>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-jtoppins-entry-to-reference-correct-email
+++ a/.mailmap
@@ -232,6 +232,8 @@ Johan Hovold <johan@kernel.org> <johan@h
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
 John Stultz <johnstul@us.ibm.com>
+<jon.toppins+linux@gmail.com> <jtoppins@cumulusnetworks.com>
+<jon.toppins+linux@gmail.com> <jtoppins@redhat.com>
 Jordan Crouse <jordan@cosmicpenguin.net> <jcrouse@codeaurora.org>
 <josh@joshtriplett.org> <josh@freedesktop.org>
 <josh@joshtriplett.org> <josh@kernel.org>
_

Patches currently in -mm which might be from jtoppins@redhat.com are

mailmap-update-jtoppins-entry-to-reference-correct-email.patch

