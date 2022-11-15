Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11573C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 00:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236787AbiKOAoN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235927AbiKOAoM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 19:44:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A0C1B1C9
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 16:44:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 271C2B810A0
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 00:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3029C433C1;
        Tue, 15 Nov 2022 00:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668473048;
        bh=lo+nK8H1NvwehMzbuw8p3RDDwVW+MuxnxhDNrEe/DIg=;
        h=Date:To:From:Subject:From;
        b=aK3nV8BmehFQEzJqaSMWFHRyB4frqw5G2bx/XdnZ24yaV3ALsw8tAJPSV1XYiWIF+
         E2xHQeYmAUtM3qWko0EkCXFGxjvpe+7BW0ouwKb+C8TYi+3Bp0D7liIbJkiKnN63DN
         4/1z/3WBkoe1lBCaDiWSAFS+LFti2aJ5wbW4a3rY=
Date:   Mon, 14 Nov 2022 16:44:08 -0800
To:     mm-commits@vger.kernel.org, alexhung@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-update-alex-hungs-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20221115004408.C3029C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mailmap: update Alex Hung's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-update-alex-hungs-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-update-alex-hungs-email-address.patch

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
From: Alex Hung <alexhung@gmail.com>
Subject: mailmap: update Alex Hung's email address
Date: Sun, 13 Nov 2022 17:13:01 -0700

I am no longer at Canonical and add entry of my personal email address.

Link: https://lkml.kernel.org/r/20221114001302.671897-1-alex.hung@amd.com
Signed-off-by: Alex Hung <alexhung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-alex-hungs-email-address
+++ a/.mailmap
@@ -29,6 +29,7 @@ Alexandre Belloni <alexandre.belloni@boo
 Alexei Starovoitov <ast@kernel.org> <alexei.starovoitov@gmail.com>
 Alexei Starovoitov <ast@kernel.org> <ast@fb.com>
 Alexei Starovoitov <ast@kernel.org> <ast@plumgrid.com>
+Alex Hung <alexhung@gmail.com> <alex.hung@canonical.com>
 Alex Shi <alexs@kernel.org> <alex.shi@intel.com>
 Alex Shi <alexs@kernel.org> <alex.shi@linaro.org>
 Alex Shi <alexs@kernel.org> <alex.shi@linux.alibaba.com>
_

Patches currently in -mm which might be from alexhung@gmail.com are

mailmap-update-alex-hungs-email-address.patch
maintainers-update-alex-hungs-email-address.patch

