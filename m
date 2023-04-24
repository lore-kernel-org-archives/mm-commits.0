Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B089C77B61
	for <mm-commits@archiver.kernel.org>; Mon, 24 Apr 2023 21:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjDXVd5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Apr 2023 17:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjDXVd4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Apr 2023 17:33:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DF959D1
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 14:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF906628DA
        for <mm-commits@vger.kernel.org>; Mon, 24 Apr 2023 21:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25009C433D2;
        Mon, 24 Apr 2023 21:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682372034;
        bh=PNeVnd30uUi+RjOcYTmvBejZS7wKWiMRuTyfoaHXhmY=;
        h=Date:To:From:Subject:From;
        b=QUyyD5Qciqhqpz2x4D3lSrCDjb8prO1lsNuPQDWK7HL33pxI+NXQFkCETB+BUerYY
         CI5ocFiEdzuyWyMcDK+s97RVW89MC/57SqIWntfL+crBWd9qTYtpRNHIfnlgSg/hcF
         wL5Hup/vptgialPdeP1STwpHM6xhBO8uNiVj07rE=
Date:   Mon, 24 Apr 2023 14:33:53 -0700
To:     mm-commits@vger.kernel.org, paulus@ozlabs.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-paul-mackerras.patch added to mm-nonmm-unstable branch
Message-Id: <20230424213354.25009C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: add entries for Paul Mackerras
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-entries-for-paul-mackerras.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-paul-mackerras.patch

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
From: Paul Mackerras <paulus@ozlabs.org>
Subject: mailmap: add entries for Paul Mackerras
Date: Mon, 24 Apr 2023 17:01:32 +1000

Link: https://lkml.kernel.org/r/ZEYpTAufVHTvsO1n@cleo
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-paul-mackerras
+++ a/.mailmap
@@ -374,6 +374,8 @@ Paul E. McKenney <paulmck@kernel.org> <p
 Paul E. McKenney <paulmck@kernel.org> <paulmck@linux.ibm.com>
 Paul E. McKenney <paulmck@kernel.org> <paulmck@linux.vnet.ibm.com>
 Paul E. McKenney <paulmck@kernel.org> <paulmck@us.ibm.com>
+Paul Mackerras <paulus@ozlabs.org> <paulus@samba.org>
+Paul Mackerras <paulus@ozlabs.org> <paulus@au1.ibm.com>
 Peter A Jonsson <pj@ludd.ltu.se>
 Peter Oruba <peter.oruba@amd.com>
 Peter Oruba <peter@oruba.de>
_

Patches currently in -mm which might be from paulus@ozlabs.org are

mailmap-add-entries-for-paul-mackerras.patch

