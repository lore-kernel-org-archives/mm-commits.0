Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40226C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 00:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387637AbiEFAwC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 20:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387649AbiEFAwC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 20:52:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEE82459F
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 17:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0021B831C4
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 00:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5896EC385A8;
        Fri,  6 May 2022 00:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651798098;
        bh=Ai9+X4Ri5KJIFMWzi1hqIbQB9A2mEon9NrFw8MDEG+0=;
        h=Date:To:From:Subject:From;
        b=B+iD78uM/WoDmSxKM+STsQHJvSuWGtQXK4mwTumIeDynpp3hiUv8M6cF8dQuXscSy
         phjhuCBJMJbR0i58JYzuqzKiOA16b2J4InZy+QDTecdyWCjGt6mAPxnUsle9vfSLOT
         E3M7iTEaWs+OWDYY/ixpOSFu6DGGk8BhaC/vx/Vg=
Date:   Thu, 05 May 2022 17:48:17 -0700
To:     mm-commits@vger.kernel.org, martyna.szapar-mudlaw@linux.intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entry-for-martynaszapar-mudlaw-intelcom.patch added to mm-hotfixes-unstable branch
Message-Id: <20220506004818.5896EC385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entry for martyna.szapar-mudlaw@intel.com
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entry-for-martynaszapar-mudlaw-intelcom.patch

This patch should soon appear in the mm-hotfixes-unstable branch at
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
From: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Subject: mailmap: add entry for martyna.szapar-mudlaw@intel.com

Separate linux.intel.com account was created for submitting and reviewing
kernel patches, thus need to map previously used primary Intel e-mail
address.

Link: https://lkml.kernel.org/r/20220505132624.41802-1-martyna.szapar-mudlaw@linux.intel.com
Signed-off-by: Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-martynaszapar-mudlaw-intelcom
+++ a/.mailmap
@@ -249,6 +249,7 @@ Mark Yao <markyao0591@gmail.com> <mark.y
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@ginzinger.com>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@puri.sm>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@theobroma-systems.com>
+Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com> <martyna.szapar-mudlaw@intel.com>
 Mathieu Othacehe <m.othacehe@gmail.com>
 Matthew Wilcox <willy@infradead.org> <matthew.r.wilcox@intel.com>
 Matthew Wilcox <willy@infradead.org> <matthew@wil.cx>
_

Patches currently in -mm which might be from martyna.szapar-mudlaw@linux.intel.com are

mailmap-add-entry-for-martynaszapar-mudlaw-intelcom.patch

