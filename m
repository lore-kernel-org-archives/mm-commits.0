Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CDDC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Jun 2022 23:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiF2Xsr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Jun 2022 19:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiF2Xsq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jun 2022 19:48:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8501FCD6
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 16:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DC8B81F21
        for <mm-commits@vger.kernel.org>; Wed, 29 Jun 2022 23:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BAEC34114;
        Wed, 29 Jun 2022 23:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656546522;
        bh=6kpNlR5negEqkQQD170jqHHnh054s/Jy7tZKKFKfvD0=;
        h=Date:To:From:Subject:From;
        b=wJYHkWaRXOXRClht0sYzJDlcasYYsq9uR9dliJ8heWjq5kSgbVTVNauj7hhQbGTwZ
         YO+14FwavRrVDQtsON6F3/BUpzUj89jIoM5o2eah7Urdl0ObCxP5KGLaDdsH89o0Bx
         PHNitFtPM20Qa4Q14LCytBH62VY9wlrbYbSVo+rY=
Date:   Wed, 29 Jun 2022 16:48:41 -0700
To:     mm-commits@vger.kernel.org, sforshee@kernel.org, seth@forshee.me,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-seth-forshees-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20220629234842.A1BAEC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Seth Forshee's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-seth-forshees-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-seth-forshees-email-address.patch

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
From: Seth Forshee <seth@forshee.me>
Subject: mailmap: update Seth Forshee's email address
Date: Tue, 28 Jun 2022 15:07:34 -0500

seth.forshee@canonical.com is no longer valid, use sforshee@kernel.org
instead.

Link: https://lkml.kernel.org/r/20220628200734.424495-1-sforshee@kernel.org
Signed-off-by: Seth Forshee <sforshee@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-seth-forshees-email-address
+++ a/.mailmap
@@ -368,6 +368,7 @@ Sean Nyekjaer <sean@geanix.com> <sean.ny
 Sebastian Reichel <sre@kernel.org> <sebastian.reichel@collabora.co.uk>
 Sebastian Reichel <sre@kernel.org> <sre@debian.org>
 Sedat Dilek <sedat.dilek@gmail.com> <sedat.dilek@credativ.de>
+Seth Forshee <sforshee@kernel.org> <seth.forshee@canonical.com>
 Shiraz Hashim <shiraz.linux.kernel@gmail.com> <shiraz.hashim@st.com>
 Shuah Khan <shuah@kernel.org> <shuahkhan@gmail.com>
 Shuah Khan <shuah@kernel.org> <shuah.khan@hp.com>
_

Patches currently in -mm which might be from seth@forshee.me are

mailmap-update-seth-forshees-email-address.patch

