Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28F1C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 22:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbiFAW6v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiFAW6v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 18:58:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77158DC803
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 15:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10CD660FD3
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 22:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61366C385B8;
        Wed,  1 Jun 2022 22:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654124329;
        bh=RJCX+X3KzJ+xVNsM0bknOc54U/JlRH5mgaNYcIymM+c=;
        h=Date:To:From:Subject:From;
        b=KGiHOYV/7u4dJ+JTT2yDZ2Xitq7UillNE498tEXbUbrb1bn9iMhz7qeJskQ+6TQlT
         ydJWrfwv5gPLyqiE6X2b42GJXRHup5LLzXLtWnw27YUTxvdHdsDOi+FfFDA1f1Hz74
         22kRw6oE4tyJt9G8t+KHwSM1KoWadNi7xtBGEVVs=
Date:   Wed, 01 Jun 2022 15:58:48 -0700
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        jpoimboe@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-update-josh-poimboeufs-email.patch removed from -mm tree
Message-Id: <20220601225849.61366C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mailmap: update Josh Poimboeuf's email
has been removed from the -mm tree.  Its filename was
     mailmap-update-josh-poimboeufs-email.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Josh Poimboeuf <jpoimboe@kernel.org>
Subject: mailmap: update Josh Poimboeuf's email
Date: Fri, 27 May 2022 13:18:52 -0700

I recently switched to my kernel.org email address.  Add aliases for my
previous Red Hat and IBM addresses.

Link: https://lkml.kernel.org/r/0519dcfbb1ee2cb82cb32b0aff61410a62949aa5.1653682698.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-update-josh-poimboeufs-email
+++ a/.mailmap
@@ -201,6 +201,8 @@ Jordan Crouse <jordan@cosmicpenguin.net>
 <josh@joshtriplett.org> <josht@linux.vnet.ibm.com>
 <josh@joshtriplett.org> <josht@us.ibm.com>
 <josh@joshtriplett.org> <josht@vnet.ibm.com>
+Josh Poimboeuf <jpoimboe@kernel.org> <jpoimboe@redhat.com>
+Josh Poimboeuf <jpoimboe@kernel.org> <jpoimboe@us.ibm.com>
 Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
_

Patches currently in -mm which might be from jpoimboe@kernel.org are


